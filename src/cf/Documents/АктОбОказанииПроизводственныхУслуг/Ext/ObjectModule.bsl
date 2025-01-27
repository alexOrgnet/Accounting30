﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ДанныеЗаполнения <> Неопределено И ТипДанныхЗаполнения <> Тип("Структура") 
		И Метаданные().ВводитсяНаОсновании.Содержит(ДанныеЗаполнения.Метаданные()) Тогда
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура")
		И ДанныеЗаполнения.Свойство("СуммаВключаетНДС") Тогда
		СуммаВключаетНДС = ДанныеЗаполнения.СуммаВключаетНДС;
	Иначе
		СуммаВключаетНДС = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию(
			"ОсновнойВариантРасчетаИсходящегоНДС") = Перечисления.ВариантыРасчетаНДС.НДСВСумме;
	КонецЕсли;
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	// Заполнение реквизитов, специфичных для документа:
	Если НЕ ЗначениеЗаполнено(СчетЗатрат) Тогда
		СчетЗатрат = ПланыСчетов.Хозрасчетный.ОсновноеПроизводство;
	КонецЕсли;
	
	// Заполним основную номенклатурную группу
	Если НЕ ЗначениеЗаполнено(НоменклатурнаяГруппа) 
		И БухгалтерскийУчетВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа() <> Неопределено Тогда
		НоменклатурнаяГруппа = БухгалтерскийУчетВызовСервераПовтИсп.ОсновнаяНоменклатурнаяГруппа();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация)
		И ЗначениеЗаполнено(Контрагент)
		И (ЗначениеЗаполнено(ДоговорКонтрагента) ИЛИ НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам")) Тогда
		Документы.АктОбОказанииПроизводственныхУслуг.ЗаполнитьСчетаУчетаРасчетов(ЭтотОбъект);
	КонецЕсли;
	
	ЗаполнениеДокументов.ЗаполнитьПодразделениеЗатрат(ПодразделениеЗатрат, Организация);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Дата          = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	ЗачетАвансов.Очистить();
	
	СтруктураКурсаВзаиморасчетов = РаботаСКурсамиВалют.ПолучитьКурсВалюты(
	ВалютаДокумента, Дата);
	
	КурсВзаиморасчетов      = СтруктураКурсаВзаиморасчетов.Курс;
	КратностьВзаиморасчетов = СтруктураКурсаВзаиморасчетов.Кратность;
	
	ОтветственныеЛицаБП.УстановитьОтветственныхЛиц(ЭтотОбъект);
	
	ЗаполнениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПлательщикНДФЛ	= УчетнаяПолитика.ПлательщикНДФЛ(Организация, Дата);
	
	// Исключаем из проверки реквизиты, заполнение которых стало необязательным:
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	// Проверка заполнения реквизитов шапки
	
	Если НЕ ПолучитьФункциональнуюОпцию("ВестиУчетПоДоговорам") Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоговорКонтрагента");
	КонецЕсли;
	
	Если НЕ ДеятельностьНаПатенте Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Патент");
	КонецЕсли;
	
	// В формах документа счет расчетов и счет авансов редактируются в специальной форме.
	// В случае, если они не заполнены, покажем сообщение возле соответствующей гиперссылки.
	МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовСКонтрагентом");
	МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаРасчетовПоАвансам");

	Если НЕ ЗначениеЗаполнено(СчетУчетаРасчетовСКонтрагентом) Тогда
		ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(,,
			НСтр("ru = 'Счет учета расчетов с контрагентом'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,
			"ПорядокУчетаРасчетов", Отказ);
	КонецЕсли;

	Если СпособЗачетаАвансов <> Перечисления.СпособыЗачетаАвансов.НеЗачитывать Тогда
		Если НЕ ЗначениеЗаполнено(СчетУчетаРасчетовПоАвансам) Тогда
			ТекстСообщения = ОбщегоНазначенияБПКлиентСервер.ПолучитьТекстСообщения(,,
				НСтр("ru = 'Счет учета расчетов по авансам'"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,,
				"ПорядокУчетаРасчетов", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ТекстСообщения = "";
		Если НЕ УчетВзаиморасчетов.ПроверитьВозможностьПроведенияВРеглУчете(
			ЭтотОбъект, ДоговорКонтрагента, ТекстСообщения) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность", 
				НСтр("ru = 'Договор'"),,, ТекстСообщения);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, 
				"ДоговорКонтрагента", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
	// Проверка заполнения табличной части "Услуги"
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.Субконто");
	МассивНепроверяемыхРеквизитов.Добавить("Услуги.СчетУчетаНДСПоРеализации");
	
	ИмяСписка = НСтр("ru = 'Услуги'");
	
	Для каждого СтрокаУслуги Из Услуги Цикл
		
		Префикс = "Услуги[" + Формат(СтрокаУслуги.НомерСтроки - 1, "ЧН=0; ЧГ=") + "].";
		
		Если СтрокаУслуги.СуммаНДС <> 0 И НЕ ЗначениеЗаполнено(СтрокаУслуги.СчетУчетаНДСПоРеализации) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",,
				НСтр("ru = 'Счет учета НДС по реализации'"), СтрокаУслуги.НомерСтроки, ИмяСписка);
			Поле = Префикс + "СчетУчетаНДСПоРеализации";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "Объект", Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПлательщикНДФЛ Тогда
		
		УчетДоходовИРасходовПредпринимателя.ПроверитьЗаполнениеСубконтоНоменклатурныеГруппы(
			ЭтотОбъект, "СчетДоходов", "Субконто", НСтр("ru = 'Субконто'"), "Услуги", НСтр("ru = 'Услуги'"), Отказ);
		
	КонецЕсли;
	
	// Табличная часть "Зачет авансов"
	Если СпособЗачетаАвансов <> Перечисления.СпособыЗачетаАвансов.ПоДокументу Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗачетАвансов");
	ИначеЕсли ЗачетАвансов.Количество() = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗачетАвансов");
	
		ТекстСообщения = НСтр("ru = 'Не введено ни одной строки с документом аванса!'");
		Поле = "ПорядокУчетаРасчетов";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, , Поле, Отказ);
	КонецЕсли;
	
	ИспользоватьПлановуюСебестоимость = Справочники.НастройкиУчетаЗатрат.ПлановаяСебестоимость(Дата, Организация);
		
	Если Не ИспользоватьПлановуюСебестоимость Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Услуги.ПлановаяСтоимость");
	КонецЕсли;
	
	// Удаляем из проверяемых реквизитов все, по которым автоматическая проверка не нужна:
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	// При групповом перепроведении реквизиты документов не меняются,
	// поэтому обновление связанных данных выполнять не требуется.
	Если ПроведениеСервер.ГрупповоеПерепроведение(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	// Посчитать суммы документа и записать ее в соответствующий реквизит шапки для показа в журналах
	СуммаДокумента = УчетНДСПереопределяемый.ПолучитьСуммуДокументаСНДС(ЭтотОбъект, "Услуги");
	
	РаботаСДоговорамиКонтрагентовБП.ЗаполнитьДоговорПередЗаписью(ЭтотОбъект);
	
	ИменаТабличныхЧастей = Новый Массив;
	ИменаТабличныхЧастей.Добавить("Услуги");
	ОбщегоНазначенияБП.ЗаполнитьИдентификаторыСтрок(ЭтотОбъект, ИменаТабличныхЧастей);
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("ПометкаУдаления", ЭтотОбъект);
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);

	Документы.КорректировкаРеализации.ОбновитьРеквизитыСвязанныхДокументовКорректировки(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
	
		УчетНДСПереопределяемый.ПроверитьСоответствиеРеквизитовСчетаФактурыВыданного(ЭтотОбъект);		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)

	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ДОКУМЕНТА
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
	Если РучнаяКорректировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПроведения = Документы.АктОбОказанииПроизводственныхУслуг.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// ПОДГОТОВКА ПРОВЕДЕНИЯ ПО ДАННЫМ ИНФОРМАЦИОННОЙ БАЗЫ
	
	// Таблица взаиморасчетов с учетом зачета авансов
	ТаблицаВзаиморасчеты = УчетВзаиморасчетов.ПодготовитьТаблицуВзаиморасчетовЗачетАвансов(
		ПараметрыПроведения.ЗачетАвансовТаблицаДокумента, ПараметрыПроведения.ЗачетАвансовТаблицаАвансов, 
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Отказ);
	
	// Таблицы выручки от реализации: собственных товаров и услуг и отдельно комиссионных 
	ТаблицыРеализация = УчетДоходовРасходов.ПодготовитьТаблицыВыручкиОтРеализации(
		ПараметрыПроведения.РеализацияТаблицаДокумента, ТаблицаВзаиморасчеты, Неопределено, 
		ПараметрыПроведения.Реквизиты, Отказ);
	
	ТаблицаСобственныеТоварыУслуги = ТаблицыРеализация.СобственныеТоварыУслуги;
	ТаблицаТоварыУслугиКомитентов = ТаблицыРеализация.ТоварыУслугиКомитентов;
	ТаблицаРеализованныеТоварыКомитентов = ТаблицыРеализация.РеализованныеТоварыКомитентов;
	
	Документы.АктОбОказанииПроизводственныхУслуг.ДобавитьКолонкуСодержание(ТаблицаСобственныеТоварыУслуги);
	
	// Структура таблиц для отражения в налоговом учете УСН
	СтруктураТаблицУСН = Новый Структура("ТаблицаРасчетов", ТаблицаВзаиморасчеты);
	
	// Учет доходов и расходов ИП
	ТаблицаОказаниеУслугИП	= УчетДоходовИРасходовПредпринимателя.ПодготовитьТаблицуОказаниеУслуг(
		ТаблицыРеализация.СобственныеТоварыУслуги, ПараметрыПроведения.Реквизиты);
		
	// ФОРМИРОВАНИЕ ДВИЖЕНИЙ
	
	УчетВзаиморасчетов.СформироватьДвиженияЗачетАвансов(ТаблицаВзаиморасчеты,
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияРеализация(
		ТаблицаСобственныеТоварыУслуги, ТаблицаТоварыУслугиКомитентов, ТаблицаРеализованныеТоварыКомитентов, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	//Движения регистра "Рублевые суммы документов в валюте"
	//Табличная часть "Услуги"
	УчетНДСБП.СформироватьДвиженияРублевыеСуммыДокументовВВалюте(ТаблицаСобственныеТоварыУслуги, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	РегистрыНакопления.РеализацияУслуг.ДобавитьДвижения(
		Движения.РеализацияУслуг,
		ПараметрыПроведения.ТаблицаРеализацияУслуг,
		ТаблицаСобственныеТоварыУслуги,
		ПараметрыПроведения.Реквизиты);
	
	УчетПроизводства.СформироватьДвиженияПлановаяСтоимостьВыпущенныхУслуг(
		ПараметрыПроведения.ПлановаяСтоимостьУслугТаблица, 
		ПараметрыПроведения.ПлановаяСтоимостьУслугРеквизиты, Движения, Отказ);
		
	УчетПроизводства.СформироватьДвиженияВыпускПродукцииУслуг(
		ПараметрыПроведения.ВыпускУслугТаблица, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетНДС.СформироватьДвиженияРеализацияТоваровУслуг(
		ТаблицаСобственныеТоварыУслуги, Неопределено, Неопределено, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	НалоговыйУчетУСН.СформироватьДвиженияУСН(ЭтотОбъект, СтруктураТаблицУСН);
		
	// Учет доходов и расходов ИП
	ТаблицаИПМПЗОтгруженные	= УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияОказаниеУслуг(
		ТаблицаОказаниеУслугИП,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	УчетДоходовИРасходовПредпринимателя.СформироватьДвиженияЗачетОплатыПокупателя(
		ТаблицаИПМПЗОтгруженные, ТаблицаВзаиморасчеты, 
		ПараметрыПроведения.ЗачетАвансовРеквизиты, Движения, Отказ);
		
	// ПЕРЕОЦЕНКА ВАЛЮТНЫХ ОСТАТКОВ
	ТаблицаПереоценка = УчетДоходовРасходов.ПодготовитьТаблицуПереоценкаВалютныхОстатковПоПроводкамДокумента(
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетДоходовРасходов.СформироватьДвиженияРасчетПереоценкиВалютныхСредств(ТаблицаПереоценка,
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
	
	УчетУСН.СформироватьДвиженияПереоценкаВалютныхОстатков(ТаблицаПереоценка, 
		ПараметрыПроведения.Реквизиты, Движения, Отказ);
		
	// Отложенные расчеты с контрагентами.
	УчетВзаиморасчетовОтложенноеПроведение.ЗарегистрироватьОтложенныеРасчетыСКонтрагентами(
		ЭтотОбъект, Отказ, ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение);
		
	// Регистрация в последовательности.
	РаботаСПоследовательностями.ЗарегистрироватьОтложенныеРасчетыВПоследовательности(
		ЭтотОбъект,
		Отказ,
		ПараметрыПроведения.РасчетыСКонтрагентамиОтложенноеПроведение,
		,
		Перечисления.ВидыРегламентныхОпераций.ЗакрытиеСчетов20_23_25_26);
		
	ПроведениеСервер.УстановитьЗаписьОчищаемыхНаборовЗаписей(ЭтотОбъект);
		
	Движения.Записать();
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект);
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);
		
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
	Движения.Записать();

	РаботаСПоследовательностями.ОтменитьРегистрациюВПоследовательности(ЭтотОбъект, Отказ);
	
	ПараметрыДействия = УчетНДСПереопределяемый.НовыеПараметрыСостоянияСчетаФактуры("Проведен", ЭтотОбъект);	
	ПараметрыДействия.СостояниеФлага = Ложь;
	УчетНДСПереопределяемый.УстановитьСостояниеСчетаФактуры(ПараметрыДействия, Отказ);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗаполнитьПоДокументуОснованию(Основание)

	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, Основание);
	СпособЗачетаАвансов = Перечисления.СпособыЗачетаАвансов.Автоматически;

	// Заполнить услуги из табличной части "Услуги"
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СчетНаОплатуПокупателю.СуммаСкидки,
	|	СчетНаОплатуПокупателю.СуммаДокумента,
	|	СчетНаОплатуПокупателю.СуммаВключаетНДС
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
	|ГДЕ
	|	СчетНаОплатуПокупателю.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетНаОплатуТовары.НомерСтроки КАК НомерСтроки,
	|	СчетНаОплатуТовары.Номенклатура КАК Номенклатура,
	|	СчетНаОплатуТовары.СтавкаНДС КАК СтавкаНДС,
	|	СчетНаОплатуТовары.Цена КАК Цена,
	|	СчетНаОплатуТовары.Количество КАК Количество,
	|	СчетНаОплатуТовары.Сумма КАК Сумма,
	|	СчетНаОплатуТовары.СуммаНДС КАК СуммаНДС,
	|	СчетНаОплатуТовары.СуммаСкидки,
	|	ЕСТЬNULL(СчетНаОплатуТовары.Номенклатура.Услуга, ИСТИНА) КАК ЭтоУслуга
	|ИЗ
	|	Документ.СчетНаОплатуПокупателю.Товары КАК СчетНаОплатуТовары
	|ГДЕ
	|	СчетНаОплатуТовары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	
	Запрос.УстановитьПараметр("Ссылка", Основание.Ссылка);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = РезультатЗапроса[0].Выгрузить();
	ТаблицаУслуг     = РезультатЗапроса[1].Выгрузить();
	
	РеквизитыОснования = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	
	Если РеквизитыОснования.СуммаСкидки <> 0 ИЛИ ТаблицаУслуг.Итог("СуммаСкидки") <> 0 Тогда
	
		ОбработкаТабличныхЧастей.РаспределитьСкидкуПоСтрокамТабЧасти(ТаблицаУслуг, РеквизитыОснования);
	
	КонецЕсли;
	
	ТаблицаУслуг.Индексы.Добавить("ЭтоУслуга");
	
	ТаблицаУслуг = ТаблицаУслуг.Скопировать(Новый Структура("ЭтоУслуга", Истина));
	
	ДанныеОбъекта = Новый Структура(
		"Дата, Организация, ДеятельностьНаПатенте,
		|ТипЦенПлановойСебестоимости, Реализация, ДокументБезНДС");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ЭтотОбъект);
	ДанныеОбъекта.ТипЦенПлановойСебестоимости = Константы.ТипЦенПлановойСебестоимостиНоменклатуры.Получить();
	ДанныеОбъекта.Реализация = Истина;
	
	СоответствиеСведенийОНоменклатуре = БухгалтерскийУчетПереопределяемый.ПолучитьСведенияОСпискеНоменклатуры(
		ОбщегоНазначения.ВыгрузитьКолонку(ТаблицаУслуг, "Номенклатура", Истина), ДанныеОбъекта);
	
	Для Каждого СтрокаУслуг Из ТаблицаУслуг Цикл
		
		СтрокаТабличнойЧасти = Услуги.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаУслуг);
		
		СведенияОНоменклатуре = СоответствиеСведенийОНоменклатуре.Получить(СтрокаУслуг.Номенклатура);
		Если СведенияОНоменклатуре = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТабличнойЧасти.ПлановаяСтоимость		= СведенияОНоменклатуре.ПлановаяСтоимость;
		СтрокаТабличнойЧасти.НоменклатурнаяГруппа	= СведенияОНоменклатуре.НоменклатурнаяГруппа;
		СтрокаТабличнойЧасти.Спецификация			= СведенияОНоменклатуре.ОсновнаяСпецификацияНоменклатуры;
		
		ОбработкаТабличныхЧастейКлиентСервер.ПересчитатьПлановуюСумму(СтрокаТабличнойЧасти, 1);
		
		Документы.АктОбОказанииПроизводственныхУслуг.ЗаполнитьСчетаУчетаВСтрокеТабличнойЧасти(
			ДанныеОбъекта, СтрокаТабличнойЧасти, "Услуги", СведенияОНоменклатуре);
		
	КонецЦикла;

КонецПроцедуры

#КонецЕсли
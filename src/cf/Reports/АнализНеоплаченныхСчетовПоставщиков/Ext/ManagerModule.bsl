﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	ПараметрыВыполненияОтчета = Новый Структура;
	ПараметрыВыполненияОтчета.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	ПараметрыВыполненияОтчета.Вставить("ИспользоватьПослеКомпоновкиМакета" , Ложь);
	ПараметрыВыполненияОтчета.Вставить("ИспользоватьПослеВыводаРезультата" , Истина);
	ПараметрыВыполненияОтчета.Вставить("ИспользоватьДанныеРасшифровки"     , Истина);
	
	Возврат ПараметрыВыполненияОтчета;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	Возврат НСтр("ru='Счета, не оплаченные поставщикам'");
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"ВалютаРегламентированногоУчета",
		ВалютаРегламентированногоУчета);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

Процедура НастроитьВариантыОтчета(Настройки, ОписаниеОтчета) Экспорт
	
	ОписаниеВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, ОписаниеОтчета, "НеоплаченныеСчетаПоставщиков");
	ОписаниеВарианта.Размещение.Вставить(Метаданные.Подсистемы.Руководителю.Подсистемы.РасчетыСПоставщиками, "");
	
	ОписаниеОтчета.ОпределитьНастройкиФормы = Истина;
	
КонецПроцедуры

//Процедура используется подсистемой варианты отчетов
//
Процедура НастройкиОтчета(Настройки) Экспорт
	
	ВариантыНастроек = ВариантыНастроек();
	Для Каждого Вариант Из ВариантыНастроек Цикл
		Настройки.ОписаниеВариантов.Вставить(Вариант.Имя, Вариант.Представление);
	КонецЦикла;
	
КонецПроцедуры

// Формирует таблицу данных для монитора руководителя по организации на текущую дату
// Параметры
// 	Организация - СправочникСсылка.Организации - Организация по которой нужны данные
// 	ДатаНач - Дата - дата начала периода
// 	ДатаКон - Дата - дата конца периода
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица с данными для монитора руководителя
//
Функция ДанныеОНеоплаченныхСчетахПоставщиков(Организация) Экспорт
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация"                   , Организация);
	Запрос.УстановитьПараметр("Период"                        , ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СчетНаОплатуПоставщика.СуммаДокумента КАК СуммаДокумента,
	|	ПРЕДСТАВЛЕНИЕ(СчетНаОплатуПоставщика.Контрагент) КАК Контрагент,
	|	СчетНаОплатуПоставщика.ДатаВходящегоДокумента КАК Дата,
	|	СчетНаОплатуПоставщика.Ссылка,
	|	СчетНаОплатуПоставщика.НомерВходящегоДокумента КАК Номер,
	|	СчетНаОплатуПоставщика.ВалютаДокумента КАК ВалютаДокумента
	|ПОМЕСТИТЬ СчетаНаОплату
	|ИЗ
	|	Документ.СчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументов КАК СтатусыДокументов
	|		ПО СчетНаОплатуПоставщика.Организация = СтатусыДокументов.Организация
	|			И СчетНаОплатуПоставщика.Ссылка = СтатусыДокументов.Документ
	|ГДЕ
	|	СчетНаОплатуПоставщика.Организация = &Организация
	|	И СчетНаОплатуПоставщика.Проведен
	|	И (СтатусыДокументов.Статус ЕСТЬ NULL 
	|			ИЛИ СтатусыДокументов.Статус В (ЗНАЧЕНИЕ(Перечисление.СтатусОплатыСчета.НеОплачен), ЗНАЧЕНИЕ(Перечисление.СтатусОплатыСчета.ОплаченЧастично)))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВалютаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Курс,
	|	КурсыВалютСрезПоследних.Кратность,
	|	КурсыВалютСрезПоследних.Валюта КАК Валюта
	|ПОМЕСТИТЬ Валюты
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Период, ) КАК КурсыВалютСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СчетаНаОплату.Контрагент,
	|	СчетаНаОплату.Дата КАК Дата,
	|	СчетаНаОплату.Ссылка,
	|	СчетаНаОплату.Номер,
	|	СчетаНаОплату.ВалютаДокумента,
	|	ВЫБОР
	|		КОГДА СчетаНаОплату.ВалютаДокумента = &ВалютаРегламентированногоУчета
	|			ТОГДА СчетаНаОплату.СуммаДокумента
	|		КОГДА НЕ Валюты.Курс ЕСТЬ NULL 
	|				И НЕ Валюты.Кратность ЕСТЬ NULL 
	|				И Валюты.Кратность <> 0
	|			ТОГДА СчетаНаОплату.СуммаДокумента * Валюты.Курс / Валюты.Кратность
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаДокумента,
	|	СчетаНаОплату.СуммаДокумента КАК СуммаВВалюте
	|ИЗ
	|	СчетаНаОплату КАК СчетаНаОплату
	|		ЛЕВОЕ СОЕДИНЕНИЕ Валюты КАК Валюты
	|		ПО СчетаНаОплату.ВалютаДокумента = Валюты.Валюта
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатВыполненияЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатВыполненияЗапроса.Пустой() Тогда
		Возврат ПустыеДанныеОНеоплаченныхСчетахПоставщиков();
	Иначе
		ДанныеНеоплаченныхСчетов = РезультатВыполненияЗапроса.Выгрузить();
		КоличествоНеоплаченныхСчетов = ДанныеНеоплаченныхСчетов.Количество();
	КонецЕсли;
	
	ТаблицаДанных = МониторРуководителя.ТаблицаДанных();
	
	Для ИндексСтроки = 0 По Мин(2, КоличествоНеоплаченныхСчетов - 1) Цикл
		
		ДанныеСчета = ДанныеНеоплаченныхСчетов[ИндексСтроки];
		ШаблонПредставления = Нстр("ru='%1: %2 от %3'");
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления,
			ДанныеСчета.Контрагент,
			ДанныеСчета.Номер,
			Формат(ДанныеСчета.Дата, "ДЛФ=D"));
		
		СтрокаДанныхМонитора                   = ТаблицаДанных.Добавить();
		СтрокаДанныхМонитора.Представление     = Представление;
		СтрокаДанныхМонитора.ДанныеРасшифровки = ДанныеСчета.Ссылка;
		СтрокаДанныхМонитора.Порядок           = ПорядокСчетовВМониторе();
		Если ВалютаРегламентированногоУчета <> ДанныеСчета.ВалютаДокумента Тогда
			СтрокаДанныхМонитора.Валюта            = ДанныеСчета.ВалютаДокумента;
			СтрокаДанныхМонитора.Сумма             = ДанныеСчета.СуммаДокумента;
			СтрокаДанныхМонитора.СуммаВВалюте      = Окр(ДанныеСчета.СуммаВВалюте, 2);
		Иначе
			СтрокаДанныхМонитора.Сумма = ДанныеСчета.СуммаДокумента;
		КонецЕсли;
		
	КонецЦикла;
	
	СтрокаДанных               = ТаблицаДанных.Добавить();
	СтрокаДанных.Представление = НСтр("ru='Итого'");
	СтрокаДанных.Порядок       = ПорядокИтоговВМониторе();
	СтрокаДанных.Сумма         = Окр(ДанныеНеоплаченныхСчетов.Итог("СуммаДокумента"), 2);
	
	Возврат ТаблицаДанных;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("ВключатьОбособленныеПодразделения", Ложь);
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	
	Возврат ПараметрыОтчета;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВариантыНастроек()
	
	ВариантыНастроек = Новый Массив;
	
	ВариантНастройки = Новый Структура();
	ВариантНастройки.Вставить("Имя"          , "НеоплаченныеСчетаПоставщиков");
	ВариантНастройки.Вставить("Представление", НСтр("ru='Счета, не оплаченные поставщикам'"));
	
	ВариантыНастроек.Добавить(ВариантНастройки);
	
	Возврат ВариантыНастроек;
	
КонецФункции

Функция ПустыеДанныеОНеоплаченныхСчетахПоставщиков()
	
	ТаблицаДанных = МониторРуководителя.ТаблицаДанных();
	
	СтрокаИтого = ТаблицаДанных.Добавить();
	СтрокаИтого.Представление = НСтр("ru='Итого'");
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ПорядокИтоговВМониторе() Экспорт
	
	Возврат 0;
	
КонецФункции

Функция ПорядокСчетовВМониторе() Экспорт
	
	Возврат 1;
	
КонецФункции

#КонецОбласти

#КонецЕсли
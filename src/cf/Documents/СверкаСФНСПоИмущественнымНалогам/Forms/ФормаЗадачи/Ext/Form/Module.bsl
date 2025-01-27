﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(Параметры.Организация) Или Не ЗначениеЗаполнено(Параметры.Налог) Или Не ЗначениеЗаполнено(
		Параметры.НалоговыйПериод) Тогда
		ВызватьИсключение НСтр("ru='Некорректно указаны параметры открытия формы.'");
	КонецЕсли;

	ТолькоПросмотр = Не ПравоДоступа("Изменение", Метаданные.Документы.СверкаСФНСПоИмущественнымНалогам);

	Параметры.Свойство("Правило", Правило);
	Параметры.Свойство("Описание", Описание);

	ИспользуетсяОтправкаОтчетовЧерез1СОтчетность = ИнтерфейсыВзаимодействияБРО.ПодключенДокументооборотСКонтролирующимОрганом(
								Параметры.Организация, Перечисления.ТипыКонтролирующихОрганов.ФНС, Ложь);

	СверкаСФНСПоИмущественнымНалогамФормы.ИнициализироватьПараметрыСверки(ЭтотОбъект,
		Параметры.РегистрацияВНалоговомОргане);
	УстановитьЗаголовокФормы();
	ЗаполнитьСуммыНалога(ЭтотОбъект);

	СверкаСФНСПоИмущественнымНалогамФормы.ИнициализироватьПараметрыНавигационныхСсылок(
		ЭтотОбъект, Параметры.Организация, Параметры.Налог, Параметры.НалоговыйПериод,
		ПараметрыСверки.КодыНалоговыхОрганов, ПараметрыСверки.РегистрацияВНалоговомОргане, ПараметрыСверки.Сообщение);

	ПроверитьСостояниеСверки();
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "СверкаСФНСПоИмущественнымНалогам_Запись" Тогда
		ПроверитьСостояниеСверки(Параметр);
	ИначеЕсли ИмяСобытия = "Запись_УведомлениеОСпецрежимахНалогообложения" Тогда
		ПриЗаписиУведомленияСервер(Источник);
	ИначеЕсли ИмяСобытия = "Запись_ПлатежныйДокумент_УплатаНалогов" Тогда
		ПриЗаписиПлатежногоДокументаСервер(Параметр);
	ИначеЕсли ИмяСобытия = "Запись_СписаниеСРасчетногоСчета" Тогда
		ПриЗаписиСписанияСРасчетногоСчетаСервер(Источник);
	ИначеЕсли ИмяСобытия = "ИзменениеВыписки" Тогда
		ПриИзмененииВыписки();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОбработкаНавигационнойСсылкиНадписи(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СверкаСФНСПоИмущественнымНалогамФормыКлиент.ОбработкаНавигационнойСсылки(
		ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКСверке(Команда)

	ОткрытьФорму("Документ.СверкаСФНСПоИмущественнымНалогам.Форма.ФормаСверки", ПараметрыФормыДетальнойСверки(), , Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗадачу(Команда)

	Если Не ЕстьПравоВыполненияЗадачи() Тогда
		ВызватьИсключение Нстр("ru='Нет прав на изменение задачи'");
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Правило) Тогда
		Правило = ПравилоСверкиНалога();
	КонецЕсли;

	ПараметрыЗадачи = Новый Структура;
	ПараметрыЗадачи.Вставить("Организация", Параметры.Организация);
	ПараметрыЗадачи.Вставить("Правило", Правило);
	ПараметрыЗадачи.Вставить("ПериодСобытия",
		СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.ПериодСобытияПоНалоговомуПериоду(Параметры.НалоговыйПериод));
	ПараметрыЗадачи.Вставить("РегистрацияВНалоговомОргане", Параметры.РегистрацияВНалоговомОргане);
	ПараметрыЗадачи.Вставить("Действие", ПредопределенноеЗначение("Перечисление.ВидыДействийКалендаряБухгалтера.Проверка"));

	ВыполнениеЗадачБухгалтераКлиент.ОтметитьЗадачуКакВыполненную(ПараметрыЗадачи, ЭтотОбъект);

	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьРасчет(Команда)
	ОповещениеПослеЗагрузкиФайла = Новый ОписаниеОповещения("ЗагрузитьРасчетПослеПомещенияФайла", ЭтотОбъект);
	СверкаСФНСПоИмущественнымНалогамФормыКлиент.НачатьЗагрузкуРасчетаНалогаИзФайла(
		ЭтотОбъект, Параметры.Налог, КонецГода(Параметры.НалоговыйПериод), ОповещениеПослеЗагрузкиФайла);
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБезФайла(Команда)
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРучнаяСверка;
	НастроитьКнопки(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяНазад(Команда)
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоискРасчета;
	НастроитьКнопки(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовокФормы()

	ПараметрыТекста = Новый Структура;
	ПараметрыТекста.Вставить("Описание", Описание);

	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	Если ИспользоватьНесколькоОрганизаций Тогда
		ШаблонТекста = НСтр("ru = '[Описание] ([Организация])'");
		НаименованиеОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Организация,
			"НаименованиеСокращенное");
		ПараметрыТекста.Вставить("Организация", НаименованиеОрганизации);
	Иначе
		ШаблонТекста = НСтр("ru = '[Описание]'");
	КонецЕсли;

	Заголовок = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ШаблонТекста, ПараметрыТекста);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСуммыНалога(Форма)

	Параметры = Форма.Параметры;

	СуммыНалога = СверкаСФНСПоИмущественнымНалогамФормы.СуммыНалога(
		Параметры.Организация, Параметры.Налог, Параметры.НалоговыйПериод, Форма.ПараметрыСверки.КодыНалоговыхОрганов);

	ЗаполнитьЗначенияСвойств(Форма, СуммыНалога);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура НастроитьЭлементыСтраницыПоискРасчета(Форма)

	Параметры = Форма.Параметры;
	ПараметрыСверки = Форма.ПараметрыСверки;
	СостоянияСверки = ПараметрыСверки.СостоянияСверки;
	Элементы = Форма.Элементы;
	
	// Результат
	ТекстНадписи = "";
	Шрифт = Элементы.НадписьРезультат.Шрифт;
	ЦветТекста = Новый Цвет;

	Если ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетДоКрайнегоСрока
		Или ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетПослеКрайнегоСрока Тогда
		ТекстНадписи = Нстр("ru='Не обнаружено сообщение из ФНС об исчисленной сумме налога'");
		ЦветТекста = ПараметрыСверки.Цвета.РасчетОтсутствует;
	ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыСошлись Тогда
		ТекстНадписи = Нстр("ru='Расчет в программе сошелся с расчетом налогового органа'");
		ЦветТекста = ПараметрыСверки.Цвета.РасчетыСошлись;
	ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыНеСошлись Тогда
		ТекстНадписи = Нстр("ru='Обнаружены расхождения между данными программы и расчетом налогового органа'");
		ЦветТекста = ПараметрыСверки.Цвета.РасчетыНеСошлись;
	ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.РучнаяСверка Тогда
		ТекстНадписи = Нстр("ru='Требуется завершить детальную сверку'");
		ЦветТекста = ПараметрыСверки.Цвета.РучнаяСверка;
	КонецЕсли;

	Элементы.НадписьРезультат.Заголовок = Новый ФорматированнаяСтрока(ТекстНадписи, Шрифт, ЦветТекста); 
	
	// Расчет налога в программе
	ТекстНадписи = Нстр("ru='По данным программы сумма налога – <a href = ""СправкаРасчет"">%1</a> руб.
						|(эту сумму организация уже должна была уплатить).'");
	ТекстНадписи = СтрЗаменить(ТекстНадписи, Символы.ПС, " ");
	ТекстНадписи = СтрШаблон(ТекстНадписи, Формат(Форма.СуммаНалога, "ЧН="));
	Элементы.НадписьРасчетВПрограмме.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(ТекстНадписи);
	
	// Расчет налога из ФНС
	ТекстНадписи = "";
	Если ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетДоКрайнегоСрока Тогда

		Абзацы = Новый Массив;

		ТекстАбзаца = Нстр("ru='Налоговая также рассчитает сумму к уплате – независимо, по своим данным.
						   |Свой расчет она пришлет до %1. На данный момент в программе нет данных о расчете ФНС.'");
		ТекстАбзаца = СтрЗаменить(ТекстАбзаца, Символы.ПС, " ");
		ТекстАбзаца = СтрШаблон(
			ТекстАбзаца, Формат(СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.КрайнийСрокПолученияРасчетаФНС(
			Параметры.НалоговыйПериод), "ДФ='d MMMM'"));
		Абзацы.Добавить(ТекстАбзаца);

		ТекстАбзаца = Нстр("ru='Возможно, расчет уже пришел. Мы рекомендуем проверить это, поскольку расхождения в расчетах
						   |могут привести к пеням и штрафам.'");
		ТекстАбзаца = СтрЗаменить(ТекстАбзаца, Символы.ПС, " ");
		Абзацы.Добавить(ТекстАбзаца);

		ТекстНадписи = СтрСоединить(Абзацы, Символы.ПС);

	ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетПослеКрайнегоСрока Тогда

		Абзацы = Новый Массив;

		ТекстАбзаца = Нстр("ru='Налоговая также рассчитала сумму к уплате – независимо, по своим данным.
						   |Свой расчет она уже должна была прислать. Но на данный момент в программе нет данных о расчете ФНС.'");
		ТекстАбзаца = СтрЗаменить(ТекстАбзаца, Символы.ПС, " ");
		Абзацы.Добавить(ТекстАбзаца);

		ТекстАбзаца = Нстр("ru='Мы рекомендуем найти и сверить расчет, поскольку расхождения в расчетах
						   |могут привести к пеням и штрафам.'");
		ТекстАбзаца = СтрЗаменить(ТекстАбзаца, Символы.ПС, " ");
		Абзацы.Добавить(ТекстАбзаца);

		ТекстНадписи = СтрСоединить(Абзацы, Символы.ПС);

	ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыСошлись
		Или ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыНеСошлись Тогда

		ТекстНадписи = Нстр("ru='Налоговая также рассчитала сумму к уплате – независимо, по своим данным.
							|<a href = ""РасчетНалоговой"">Сообщение об исчисленной сумме налога</a> получено через
							|<a href = ""РегОтчетность"">1С-Отчетность</a>.'");
		ТекстНадписи = СтрЗаменить(ТекстНадписи, Символы.ПС, " ");
		ТекстНадписи = СтроковыеФункции.ФорматированнаяСтрока(ТекстНадписи);

	ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.РучнаяСверка Тогда

		ТекстНадписи = Нстр("ru='Сверка выполняется в ручном режиме. Чтобы указать расхождения с налоговой,
							|вернитесь к детальной сверке.'");
		ТекстНадписи = СтрЗаменить(ТекстНадписи, Символы.ПС, " ");

	КонецЕсли;

	Элементы.НадписьРасчетФНС.Заголовок = ТекстНадписи;
	
	// Дальнейшие действия
	ТекстНадписи = "";
	Если ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетДоКрайнегоСрока
		Или ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетПослеКрайнегоСрока Тогда

		Абзацы = Новый Массив;

		Если Форма.ИспользуетсяОтправкаОтчетовЧерез1СОтчетность Тогда
			ТекстАбзаца = Нстр("ru='В первую очередь, проверьте в <a href = ""РегОтчетность"">1С-Отчетности</a>
							   |и <a href = ""ЛичныйКабинетНалогоплательщика"">личном кабинете налогоплательщика</a>.'");
		Иначе
			ТекстАбзаца = Нстр("ru='В первую очередь, проверьте в
							   |<a href = ""ЛичныйКабинетНалогоплательщика"">личном кабинете налогоплательщика</a>.'");
		КонецЕсли;

		ТекстАбзаца = СтрЗаменить(ТекстАбзаца, Символы.ПС, " ");
		Абзацы.Добавить(ТекстАбзаца);

		ТекстАбзаца = Нстр("ru='С 1 мая 2022 года налоговая присылает сообщения в машиночитаемом xml-формате.
						   |Наименование файла, приложенного к сообщению, начинается на ""%1"".'");
		ТекстАбзаца = СтрЗаменить(ТекстАбзаца, Символы.ПС, " ");

		КНДФормыРасчета = "";
		Если Год(Параметры.НалоговыйПериод) >= 2022 Тогда // начиная с 2023 года (т.е. с расчета за 2022 год) форма расчета одна на 3 налога
			КНДФормыРасчета = СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.КНДРасчетаИмущественныхНалогов();
		ИначеЕсли Форма.Параметры.Налог = ПредопределенноеЗначение(
			"Перечисление.ВидыИмущественныхНалогов.ТранспортныйНалог") Тогда
			КНДФормыРасчета = СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.КНДРасчетаТранспортногоНалога();
		ИначеЕсли Форма.Параметры.Налог = ПредопределенноеЗначение(
			"Перечисление.ВидыИмущественныхНалогов.ЗемельныйНалог") Тогда
			КНДФормыРасчета = СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.КНДРасчетаЗемельногоНалога();
		КонецЕсли;

		ТекстАбзаца = СтрШаблон(ТекстАбзаца, КНДФормыРасчета);
		Абзацы.Добавить(ТекстАбзаца);

		ТекстАбзаца = Нстр("ru='Если расчет нашелся, загрузите xml-файл – программа сама сравнит расчеты.'");
		Абзацы.Добавить(ТекстАбзаца);

		ТекстНадписи = СтроковыеФункции.ФорматированнаяСтрока(СтрСоединить(Абзацы, Символы.ПС));

	ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыСошлись Тогда

		ТекстНадписи = Нстр("ru='Дальнейших действий не требуется.'");

	ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыНеСошлись
		Или ПараметрыСверки.СостояниеСверки = СостоянияСверки.РучнаяСверка Тогда

		ТекстНадписи = Нстр("ru='Перечень дальнейших действий смотрите в детальной сверке.'");

	КонецЕсли;

	Элементы.НадписьДействия.Заголовок = ТекстНадписи;

КонецПроцедуры

&НаСервереБезКонтекста
Процедура НастроитьЭлементыСтраницыРучнаяСверка(Форма)

	Параметры = Форма.Параметры;
	Элементы = Форма.Элементы;
	Абзацы = Новый Массив;
	
	// Как получить расчет налога в бумажном виде
	ТекстАбзаца = Нстр("ru='Также вы могли получить расчет на бумаге – заказным письмом или лично в налоговом органе.
					   |Расчет выглядит <a href = ""КартинкаРасчетНалога"">так</a>.'");
	ТекстАбзаца = СтрЗаменить(ТекстАбзаца, Символы.ПС, " ");
	Абзацы.Добавить(ТекстАбзаца);

	ТекстАбзаца = Нстр("ru='В этом случае сверять придется вручную.
					   |Найдите в расчете таблицу ""%1"", сверьте итоговые цифры. Напоминаем, по данным программы сумма налога –
					   |<a href = ""СправкаРасчет"">%2</a> руб..'");

	ИмяТаблицы = "";
	Если Параметры.Налог = Перечисления.ВидыИмущественныхНалогов.ТранспортныйНалог Тогда
		ИмяТаблицы = Нстр("ru='Исчисление транспортного налога'");
	ИначеЕсли Параметры.Налог = Перечисления.ВидыИмущественныхНалогов.ЗемельныйНалог Тогда
		ИмяТаблицы = Нстр("ru='Исчисление земельного налога'");
	ИначеЕсли Параметры.Налог = Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество Тогда
		ИмяТаблицы = Нстр("ru='Исчисление налога на имущество организаций'");
	КонецЕсли;

	ТекстАбзаца = СтрШаблон(ТекстАбзаца, ИмяТаблицы, Формат(Форма.СуммаНалога, "ЧН="));
	ТекстАбзаца = СтрЗаменить(ТекстАбзаца, Символы.ПС, " ");
	Абзацы.Добавить(ТекстАбзаца);

	ТекстАбзаца = Нстр(
		"ru='Если необходимо, программа <a href = ""ПерейтиКСверке"">поможет сверить</a> и детальные данные.'");
	Абзацы.Добавить(ТекстАбзаца);

	Элементы.НадписьКакПолучитьРасчетНалогаБумажный.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(СтрСоединить(
		Абзацы, Символы.ПС));
	
	// Запросить расчет налога
	ТекстНадписи = Новый Массив;

	Шаблон = Нстр("ru='Если вы не нашли расчет за %1 год'");
	Шаблон = СтрШаблон(Шаблон, Формат(Параметры.НалоговыйПериод, "ДФ=yyyy;"));
	ТекстНадписи.Добавить(Новый ФорматированнаяСтрока(Шаблон, Новый Шрифт(, , , Истина)));
	ТекстНадписи.Добавить(Нстр("ru=', '"));
	ТекстНадписи.Добавить(СтроковыеФункции.ФорматированнаяСтрока(Нстр(
		"ru='<a href = ""ЗаявлениеОПередачеРасчета"">запросите его</a>.'")));

	Элементы.ЗаголовокЗапроситьРасчет.Заголовок = Новый ФорматированнаяСтрока(ТекстНадписи);
	
	// Что делать, если обнаружены ошибки
	ТекстНадписи = Новый Массив;

	Шаблон = Нстр("ru='Если ошибка в вашем учете –
				  |<a href = ""ПерейтиКНастройкамОбъектов"">исправьте</a> ее, <a href = ""ДоплатитьНалог"">доплатите налог и пени</a>.
				  |Отправлять какие-то формы в налоговую в этом случае не нужно.'");

	Шаблон = СтрЗаменить(Шаблон, Символы.ПС, " ");
	ТекстНадписи.Добавить(СтроковыеФункции.ФорматированнаяСтрока(Шаблон));
	ТекстНадписи.Добавить(Символы.ПС);
	ТекстНадписи.Добавить(Символы.ПС);

	Шаблон = Нстр("ru='Если ошибка в расчете ФНС, то в течение 20 дней с момента получения расчета
				  |отправьте пояснения и подтверждающие документы.'");

	// Удаляем лишние переносы строк, которые выше используются только для удобства чтения - 
	// фактически переносы подстроятся под ширину формы.
	Шаблон = СтрЗаменить(Шаблон, Символы.ПС, " ");
	ТекстНадписи.Добавить(Шаблон);
	ТекстНадписи.Добавить(Символы.ПС);

	Шаблон = Нстр("ru='В зависимости от того, в чем заключаются расхождения, нужно отправлять разные формы:
				  |- если в расчете ФНС не учтены льготы, отправьте <a href = ""ЗаявлениеОЛьготе"">заявление о предоставлении налоговой льготы</a>'");

	Если Параметры.Налог = Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество Тогда
		Шаблон = СтрЗаменить(Шаблон, "ЗаявлениеОЛьготе", "ЗаявлениеОЛьготеПоИмуществу")
	КонецЕсли;

	ТекстНадписи.Добавить(СтроковыеФункции.ФорматированнаяСтрока(Шаблон));
	ТекстНадписи.Добавить(Символы.ПС);

	Если Параметры.Налог = Перечисления.ВидыИмущественныхНалогов.ТранспортныйНалог Тогда

		Шаблон = Нстр("ru='- если ФНС посчитала налог по уничтоженному транспортному средству,
					  |отправьте <a href = ""ЗаявлениеОГибелиТС"">заявление о гибели или уничтожении ТС</a>'");
		Шаблон = СтрЗаменить(Шаблон, Символы.ПС, " ");

		ТекстНадписи.Добавить(СтроковыеФункции.ФорматированнаяСтрока(Шаблон));
		ТекстНадписи.Добавить(Символы.ПС);

	КонецЕсли;

	Шаблон = Нстр(
		"ru='- о других ошибках поясните в <a href = ""ПоясненияВСвязиССообщениемОРасчетеНалога"">специальной форме</a>.'");

	ТекстНадписи.Добавить(СтроковыеФункции.ФорматированнаяСтрока(Шаблон));
	ТекстНадписи.Добавить(Символы.ПС);
	ТекстНадписи.Добавить(Символы.ПС);

	Шаблон = Нстр("ru='Если в расчете ФНС нет %1, по которым вы платите налог,
				  |<a href = ""СообщениеОНаличииОбъектов"">сообщите об этом</a> до 31 декабря.'");
	
	// Удаляем лишние переносы строк, которые выше используются только для удобства чтения - 
	// фактически переносы подстроятся под ширину формы.
	Шаблон = СтрЗаменить(Шаблон, Символы.ПС, " ");

	ОбъектыНалогообложенияВРодительномПадеже = "";
	Если Параметры.Налог = Перечисления.ВидыИмущественныхНалогов.ТранспортныйНалог Тогда
		ОбъектыНалогообложенияВРодительномПадеже = Нстр("ru='транспортных средств'");
	ИначеЕсли Параметры.Налог = Перечисления.ВидыИмущественныхНалогов.ЗемельныйНалог Тогда
		ОбъектыНалогообложенияВРодительномПадеже = Нстр("ru='земельных участков'");
	ИначеЕсли Параметры.Налог = Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество Тогда
		ОбъектыНалогообложенияВРодительномПадеже = Нстр("ru='объектов недвижимости'");
	КонецЕсли;

	Шаблон = СтрШаблон(Шаблон, ОбъектыНалогообложенияВРодительномПадеже);

	ТекстНадписи.Добавить(СтроковыеФункции.ФорматированнаяСтрока(Шаблон));
	ТекстНадписи.Добавить(Символы.ПС);
	ТекстНадписи.Добавить(Символы.ПС);

	Шаблон = Нстр(
		"ru='В ходе <a href = ""ПерейтиКСверке"">детальной сверки</a> программа поможет составить все эти формы.'");
	ТекстНадписи.Добавить(СтроковыеФункции.ФорматированнаяСтрока(Шаблон));

	Элементы.НадписьОбнаруженыОшибки.Заголовок = Новый ФорматированнаяСтрока(ТекстНадписи);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьКнопки(Форма)

	ПараметрыСверки = Форма.ПараметрыСверки;
	СостоянияСверки = ПараметрыСверки.СостоянияСверки;
	Элементы = Форма.Элементы;

	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПоискРасчета Тогда

		Если ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетДоКрайнегоСрока
			Или ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетПослеКрайнегоСрока Тогда

			Элементы.ПоискРасчетаЗагрузитьРасчет.Видимость = Истина;
			Элементы.ПоискРасчетаЗагрузитьРасчет.КнопкаПоУмолчанию = Истина;
			Элементы.ПоискРасчетаПродолжитьБезФайла.Видимость = Истина;
			Элементы.ПоискРасчетаЗавершитьЗадачу.Видимость = Истина;
			Элементы.ПоискРасчетаЗавершитьЗадачу.Заголовок = Нстр("ru='Больше не напоминать'");
			Элементы.ПоискРасчетаЗавершитьЗадачу.Ширина = 17;
			Элементы.ПоискРасчетаПерейтиКСверке.Видимость = Ложь;

		ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыСошлись Тогда

			Элементы.ПоискРасчетаЗагрузитьРасчет.Видимость = Ложь;
			Элементы.ПоискРасчетаПродолжитьБезФайла.Видимость = Ложь;
			Элементы.ПоискРасчетаЗавершитьЗадачу.Видимость = Истина;
			Элементы.ПоискРасчетаЗавершитьЗадачу.КнопкаПоУмолчанию = Истина;
			Элементы.ПоискРасчетаЗавершитьЗадачу.Заголовок = Нстр("ru='Больше не напоминать'");
			Элементы.ПоискРасчетаЗавершитьЗадачу.Ширина = 19;
			Элементы.ПоискРасчетаПерейтиКСверке.Видимость = Истина;
			Элементы.ПоискРасчетаПерейтиКСверке.Заголовок = Нстр("ru='Перейти к детальной сверке'");
			Элементы.ПоискРасчетаПерейтиКСверке.Ширина = 20;

		ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыНеСошлись Тогда

			Элементы.ПоискРасчетаЗагрузитьРасчет.Видимость = Ложь;
			Элементы.ПоискРасчетаПродолжитьБезФайла.Видимость = Ложь;
			Элементы.ПоискРасчетаЗавершитьЗадачу.Видимость = Ложь;
			Элементы.ПоискРасчетаПерейтиКСверке.Видимость = Истина;
			Элементы.ПоискРасчетаПерейтиКСверке.КнопкаПоУмолчанию = Истина;
			Элементы.ПоискРасчетаПерейтиКСверке.Заголовок = Нстр("ru='Перейти к детальной сверке'");
			Элементы.ПоискРасчетаПерейтиКСверке.Ширина = 0; // автоширина		

		ИначеЕсли ПараметрыСверки.СостояниеСверки = СостоянияСверки.РучнаяСверка Тогда

			Элементы.ПоискРасчетаЗагрузитьРасчет.Видимость = Ложь;
			Элементы.ПоискРасчетаПродолжитьБезФайла.Видимость = Ложь;
			Элементы.ПоискРасчетаЗавершитьЗадачу.Видимость = Истина;
			Элементы.ПоискРасчетаЗавершитьЗадачу.Заголовок = Нстр("ru='Расчет сошелся, больше не напоминать'");
			Элементы.ПоискРасчетаЗавершитьЗадачу.Ширина = 28;
			Элементы.ПоискРасчетаПерейтиКСверке.Видимость = Истина;
			Элементы.ПоискРасчетаПерейтиКСверке.КнопкаПоУмолчанию = Истина;
			Элементы.ПоискРасчетаПерейтиКСверке.Заголовок = Нстр("ru='Вернуться к детальной сверке'");
			Элементы.ПоискРасчетаПерейтиКСверке.Ширина = 24;

		КонецЕсли;

	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаРучнаяСверка Тогда

		Элементы.РучнаяСверкаПерейтиКСверке.КнопкаПоУмолчанию = Истина;

	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	ПараметрыСверки = Форма.ПараметрыСверки;
	СостоянияСверки = ПараметрыСверки.СостоянияСверки;

	НастроитьЭлементыСтраницыПоискРасчета(Форма);

	Если ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетДоКрайнегоСрока
		Или ПараметрыСверки.СостояниеСверки = СостоянияСверки.ОтсутствуетПослеКрайнегоСрока Тогда
		НастроитьЭлементыСтраницыРучнаяСверка(Форма);
	ИначеЕсли Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаРучнаяСверка Тогда
		// Эта страница имеет смысл, только пока отсутствует расчет. Но в данном случае расчет уже есть.
		// Поэтому нужно вернуться на основную страницу.
		Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.СтраницаПоискРасчета;
	КонецЕсли;

	НастроитьКнопки(Форма);

КонецПроцедуры

&НаСервере
Процедура ПроверитьСостояниеСверки(ДокументСсылкаСверкаСФНС = Неопределено)

	СостоянияСверки = ПараметрыСверки.СостоянияСверки;
	// По умолчанию считаем, что сверка отсуствует, а ниже уточняем состояние
	ПараметрыСверки.СостояниеСверки = ?(ОбщегоНазначения.ТекущаяДатаПользователя()
		<= СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.КрайнийСрокПолученияРасчетаФНС(Параметры.НалоговыйПериод),
		СостоянияСверки.ОтсутствуетДоКрайнегоСрока, СостоянияСверки.ОтсутствуетПослеКрайнегоСрока);

	Если ДокументСсылкаСверкаСФНС = Неопределено Тогда
		ДокументСсылкаСверкаСФНС = Документы.СверкаСФНСПоИмущественнымНалогам.НайтиСуществующий(
			Параметры.Организация, Параметры.Налог, Параметры.НалоговыйПериод, ПараметрыСверки.КодОтправителя);
	Иначе
		// Вызов через оповещение о записи сверки. Проверим, относится ли она к текущей задаче.	
		РеквизитыСверки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДокументСсылкаСверкаСФНС, "Организация, Налог, НалоговыйПериод, КодОтправителя, ПометкаУдаления");
		Если РеквизитыСверки.ПометкаУдаления Или Параметры.Организация <> РеквизитыСверки.Организация
			Или Параметры.Налог <> РеквизитыСверки.Налог Или Параметры.НалоговыйПериод <> РеквизитыСверки.НалоговыйПериод
			Или ПараметрыСверки.КодОтправителя <> РеквизитыСверки.КодОтправителя Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;	
	
	// Если налоговый орган посчитал налог по всей организации (включая регистрации вне места нахождения организации), 
	// то отправитель может не совпадать с налоговым органом, где фактически учтены объекты налогообложения. 
	// Чтобы учесть такой случай ищем сверку, в которую попали объекты, учтенные в текущем налоговом органе.
	// При этом такой поиск имеет смысл, только если не загружалось сообщение с расчетом налога, ведь в ином случае
	// достаточно поискать сверку по коду отправителя (см. выше Документы.СверкаСФНСПоИмущественнымНалогам.НайтиСуществующий()).
	Если ДокументСсылкаСверкаСФНС = Неопределено И Не ЗначениеЗаполнено(ПараметрыСверки.Сообщение) Тогда
		КодНалоговогоОргана = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.РегистрацияВНалоговомОргане, "Код");
		ДокументСсылкаСверкаСФНС =  Документы.СверкаСФНСПоИмущественнымНалогам.НайтиСуществующийПоКодуНалоговогоОргана(
			Параметры.Организация, Параметры.Налог, Параметры.НалоговыйПериод, КодНалоговогоОргана);
	КонецЕсли;

	Если ЗначениеЗаполнено(ДокументСсылкаСверкаСФНС) Тогда

		ДокументОбъектСверкаСФНС = ДокументСсылкаСверкаСФНС.ПолучитьОбъект();
		Если ДокументОбъектСверкаСФНС.ЗагруженРасчетФНС И ДокументОбъектСверкаСФНС.РасчетыСовпадают() Тогда
			ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыСошлись;
		ИначеЕсли ДокументОбъектСверкаСФНС.ЗагруженРасчетФНС Тогда
			ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыНеСошлись;
		Иначе
			ПараметрыСверки.СостояниеСверки = СостоянияСверки.РучнаяСверка;
		КонецЕсли;

		ИнициализированаСверка = Ложь; // не требуется дальнейшая запись объекта

	ИначеЕсли ЗначениеЗаполнено(ПараметрыСверки.Сообщение) И Не ИнициализированаСверка Тогда
		// Заполняем новую сверку и на ее основании определяем результат
		ДокументОбъектСверкаСФНС = РеквизитФормыВЗначение("ДокументСверкаСФНС");

		ДанныеЗаполнения = Новый Структура;
		ДанныеЗаполнения.Вставить("Организация", Параметры.Организация);
		ДанныеЗаполнения.Вставить("Налог", Параметры.Налог);
		ДанныеЗаполнения.Вставить("НалоговыйПериод", Параметры.НалоговыйПериод);
		ДанныеЗаполнения.Вставить("КодОтправителя", ПараметрыСверки.КодОтправителя);
		ДанныеЗаполнения.Вставить("КодыНалоговыхОрганов", ПараметрыСверки.КодыНалоговыхОрганов);
		ДанныеЗаполнения.Вставить("РегистрацияВНалоговомОргане", ПараметрыСверки.РегистрацияВНалоговомОргане);
		ДанныеЗаполнения.Вставить("СообщениеФНС", ПараметрыСверки.Сообщение);

		ДокументОбъектСверкаСФНС.Заполнить(ДанныеЗаполнения);

		Если ДокументОбъектСверкаСФНС.РасчетыСовпадают() Тогда
			ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыСошлись;
		Иначе
			ПараметрыСверки.СостояниеСверки = СостоянияСверки.АвтоматическаяСверкаРасчетыНеСошлись;
		КонецЕсли;

		ЗначениеВРеквизитФормы(ДокументОбъектСверкаСФНС, "ДокументСверкаСФНС");
		ИнициализированаСверка = Истина; // признак того, что сверка, на основании которой определено состояние, требует записи

	КонецЕсли;

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Функция ПараметрыФормыДетальнойСверки() Экспорт

	ДокументСсылкаСверкаСФНС = Документы.СверкаСФНСПоИмущественнымНалогам.НайтиСуществующий(
		Параметры.Организация, Параметры.Налог, Параметры.НалоговыйПериод, ПараметрыСверки.КодОтправителя);

	// Если налоговый орган посчитал налог по всей организации (включая регистрации вне места нахождения организации), 
	// то отправитель может не совпадать с налоговым органом, где фактически учтены объекты налогообложения. 
	// Чтобы учесть такой случай ищем сверку, в которую попали объекты, учтенные в текущем налоговом органе.
	// При этом такой поиск имеет смысл, только если не загружалось сообщение с расчетом налога, ведь в ином случае
	// достаточно поискать сверку по коду отправителя (см. выше Документы.СверкаСФНСПоИмущественнымНалогам.НайтиСуществующий()).
	Если ДокументСсылкаСверкаСФНС = Неопределено И Не ЗначениеЗаполнено(ПараметрыСверки.Сообщение) Тогда
		КодНалоговогоОргана = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.РегистрацияВНалоговомОргане, "Код");
		ДокументСсылкаСверкаСФНС =  Документы.СверкаСФНСПоИмущественнымНалогам.НайтиСуществующийПоКодуНалоговогоОргана(
			Параметры.Организация, Параметры.Налог, Параметры.НалоговыйПериод, КодНалоговогоОргана);
	КонецЕсли;

	ПараметрыФормы = Новый Структура;

	Если ЗначениеЗаполнено(ДокументСсылкаСверкаСФНС) Тогда
		ПараметрыФормы.Вставить("Ключ", ДокументСсылкаСверкаСФНС);
	ИначеЕсли ИнициализированаСверка Тогда
		ДокументОбъектСверкаСФНС = РеквизитФормыВЗначение("ДокументСверкаСФНС");
		Контейнер = Новый Соответствие;
		Контейнер.Вставить("Объект", ДокументОбъектСверкаСФНС);
		ПараметрыФормы.Вставить("АдресОбъекта", ПоместитьВоВременноеХранилище(Контейнер, УникальныйИдентификатор));

		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("ЗаполнениеИзОбъекта", Истина);
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	Иначе
		// Для поиска формы заполняем ключевые параметры
		ПараметрыФормы.Вставить("Организация", Параметры.Организация);
		ПараметрыФормы.Вставить("Налог", Параметры.Налог);
		ПараметрыФормы.Вставить("НалоговыйПериод", Параметры.НалоговыйПериод);
		ПараметрыФормы.Вставить("КодОтправителя", ПараметрыСверки.КодОтправителя);

		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Организация", Параметры.Организация);
		ЗначенияЗаполнения.Вставить("Налог", Параметры.Налог);
		ЗначенияЗаполнения.Вставить("НалоговыйПериод", Параметры.НалоговыйПериод);
		ЗначенияЗаполнения.Вставить("КодОтправителя", ПараметрыСверки.КодОтправителя);
		ЗначенияЗаполнения.Вставить("РегистрацияВНалоговомОргане", ПараметрыСверки.РегистрацияВНалоговомОргане);
		Если ЗначениеЗаполнено(ПараметрыСверки.Сообщение) Тогда
			ЗначенияЗаполнения.Вставить("СообщениеФНС", ПараметрыСверки.Сообщение);
		КонецЕсли;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КонецЕсли;

	// Также передаем закэшированные параметры
	ПараметрыФормы.Вставить("Правило", Правило);
	ПараметрыФормы.Вставить("Описание", Описание);
	ПараметрыФормы.Вставить("ПараметрыНавигационныхСсылок", ПараметрыНавигационныхСсылок);
	ПараметрыФормы.Вставить("ПараметрыСверки", ПараметрыСверки);

	Возврат ПараметрыФормы;

КонецФункции

&НаСервере
Процедура ПриЗаписиУведомленияСервер(УведомлениеСсылка)

	Если ТипЗнч(УведомлениеСсылка) <> Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения") Тогда
		Возврат;
	КонецЕсли;

	РеквизитыУведомления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УведомлениеСсылка,
		"Организация, ВидУведомления, ДатаПодписи");

	КонецОтчетногоПериода = УправлениеВнеоборотнымиАктивамиВызовСервера.ПоследнийОтчетныйПериодПоДатеУведомления(
		РеквизитыУведомления.ДатаПодписи);

	Если РеквизитыУведомления.Организация <> Параметры.Организация Или Параметры.НалоговыйПериод < НачалоГода(
		КонецОтчетногоПериода) Или Параметры.НалоговыйПериод > КонецОтчетногоПериода Тогда
		Возврат;
	КонецЕсли;	
		
	// Только некоторые виды уведомлений влияют на навигационные ссылки и вид текущей формы.
	// Эти виды уведомлений перечислены в общих параметрах навигационных ссылок.
	Для Каждого УсловиеПоВидуУведомления Из ПараметрыНавигационныхСсылок.ОбщиеПараметры.УсловияПоВидуУведомления Цикл

		Если УсловиеПоВидуУведомления.Значение <> РеквизитыУведомления.ВидУведомления Тогда
			Продолжить;
		КонецЕсли;

		СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.УстановитьСпециальныйПараметрНавигационнойСсылки(
			ЭтотОбъект, УсловиеПоВидуУведомления.Ключ, "Выполнено", Истина);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиПлатежногоДокументаСервер(ПараметрыПлатежногоДокумента)

	Если ПараметрыПлатежногоДокумента.Организация <> Параметры.Организация Тогда
		Возврат;
	КонецЕсли;	
		
	// Найдем навигационные ссылки, которые зависят от платежных документов, и обновим их параметры.
	Для Каждого ПрочееУсловие Из ПараметрыНавигационныхСсылок.ОбщиеПараметры.ПрочиеУсловия Цикл

		Если ПрочееУсловие.Значение <> "ЕстьДокументУплаты" Тогда
			Продолжить;
		КонецЕсли;

		СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.УстановитьСпециальныйПараметрНавигационнойСсылки(
			ЭтотОбъект, ПрочееУсловие.Ключ, "Выполнено", Истина, Истина);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиСписанияСРасчетногоСчетаСервер(СписаниеСсылка)

	РеквизитыСписания = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СписаниеСсылка, "Организация, ВидОперации, Дата");

	КонецОтчетногоПериода = УправлениеВнеоборотнымиАктивамиВызовСервера.ПоследнийОтчетныйПериодПоДатеУведомления(
		РеквизитыСписания.Дата);

	Если РеквизитыСписания.Организация <> Параметры.Организация Или РеквизитыСписания.ВидОперации
		<> Перечисления.ВидыОперацийСписаниеДенежныхСредств.ПеречислениеНалога Или Параметры.НалоговыйПериод
		< НачалоГода(КонецОтчетногоПериода) Или Параметры.НалоговыйПериод > КонецОтчетногоПериода Тогда
		Возврат;
	КонецЕсли;	
		
	// Найдем навигационные ссылки, которые зависят от платежных документов, и обновим их параметры.
	Для Каждого ПрочееУсловие Из ПараметрыНавигационныхСсылок.ОбщиеПараметры.ПрочиеУсловия Цикл

		Если ПрочееУсловие.Значение <> "ЕстьДокументУплаты" Тогда
			Продолжить;
		КонецЕсли;

		СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.УстановитьСпециальныйПараметрНавигационнойСсылки(
			ЭтотОбъект, ПрочееУсловие.Ключ, "Выполнено", Истина, Истина);

	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииВыписки()
		
	// Найдем навигационные ссылки, которые зависят от платежных документов, и обновим их параметры.
	Для Каждого ПрочееУсловие Из ПараметрыНавигационныхСсылок.ОбщиеПараметры.ПрочиеУсловия Цикл

		Если ПрочееУсловие.Значение <> "ЕстьДокументУплаты" Тогда
			Продолжить;
		КонецЕсли;

		СверкаСФНСПоИмущественнымНалогамФормыКлиентСервер.УстановитьСпециальныйПараметрНавигационнойСсылки(
			ЭтотОбъект, ПрочееУсловие.Ключ, "Выполнено", Истина, Истина);

	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ЕстьПравоВыполненияЗадачи()
	Возврат КалендарьБухгалтера.ПравоВыполненияЗадачи(Неопределено);
КонецФункции

&НаСервере
Функция ПравилоСверкиНалога()

	Возврат Справочники.ПравилаПредставленияОтчетовУплатыНалогов.НайтиПоИдентификатору(
		Перечисления.ВидыИмущественныхНалогов.КодНалогаВЗадачахБухгалтера(Параметры.Налог), "СверкаРасчета");

КонецФункции

#Область ЗагрузкаРасчетаИзФайла

&НаКлиенте
Процедура ЗагрузитьРасчетПослеПомещенияФайла(ПомещенныйФайл, ОповещениеПослеЗагрузкиФайла) Экспорт

	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ИмяФайла = ПомещенныйФайл.Имя; // полный путь к файлу (исключение - веб-клиент без расширения работы с файлами: там будет имя файла)
	
	// Из полного пути оставляем только имя файла. 
	РазделительПутиФайла = СтрНайти(ИмяФайла, "\", НаправлениеПоиска.СКонца);
	Если РазделительПутиФайла = 0 Тогда
		РазделительПутиФайла = СтрНайти(ИмяФайла, "/", НаправлениеПоиска.СКонца);
	КонецЕсли;

	Если РазделительПутиФайла > 0 Тогда
		ИмяФайла = Сред(ИмяФайла, РазделительПутиФайла + 1);
	КонецЕсли;

	Файл = Новый Структура("Данные, ИмяФайла", ПомещенныйФайл.Хранение, ИмяФайла);
	Отбор = Новый Структура;
	Отбор.Вставить("Организация", Параметры.Организация);
	Отбор.Вставить("Налог", Параметры.Налог);
	Отбор.Вставить("НалоговыйПериод", Параметры.НалоговыйПериод);

	СписокРасчетовИзФайла = СверкаСФНСПоИмущественнымНалогамФормыВызовСервера.СписокРасчетовИзФайла(Файл, Отбор);
	СверкаСФНСПоИмущественнымНалогамФормыКлиент.ПерейтиКСверкеПослеФормированияСпискаРасчетовНалога(ЭтотОбъект,
		СписокРасчетовИзФайла);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Отчет предназначен для расшифровки расходов в декларации по налогу на прибыль в терминах, понятных ИФНС
// Из-за неоднородности данных по различным строкам декларации, 
// группировка отчета выполняется по приоритетности субконто/кор.субконто. 
//
// Если проводки по расшифровываемым расходам за период содержат эти субконто, 
// то отчет группируется по ним (в порядке убывания приоритетности).
//
// Вариант отчета РасходыПоСтатьямЗатрат(верхний уровень расшифровки)
//  На первом уровне:
//   - СправочникСсылка.НоменклатурныеГруппы
//   - ПеречислениеСсылка.ВидыРасходовНУ
//   - ПеречислениеСсылка.ВидыПрочихДоходовИРасходов
//   - СправочникСсылка.Контрагенты
//   - СправочникСсылка.РегистрацииВНалоговомОргане
//  Если ни одного из этих субконто нет, отчет группируется по КорСубконто1
//
//  На втором уровне:
//   - СправочникСсылка.СтатьиЗатрат
//   - СправочникСсылка.ПрочиеДоходыИРасходы
//   - СправочникСсылка.Контрагенты
//   - СправочникСсылка.РегистрацииВНалоговомОргане
//  Если ни одного из этих субконто нет, отчет группируется по КорСубконто1
//
// Вариант отчета РасшифровкаПоказателей(детальная расшифровка) содержит один уровень группировки:
//   - ПеречислениеСсылка.ВидыПрочихДоходовИРасходов
//   - СправочникСсылка.СтатьиЗатрат
//   - СправочникСсылка.Контрагенты
//   - СправочникСсылка.РегистрацииВНалоговомОргане
//  Если ни одного из этих субконто нет, отчет группируется по КорСубконто1
//
// Для косвенных расходов вариант РасшифровкаПоказателей формируется по кор. счетам, 
// чтобы проследить эти расходы до счетов, с которых они пришли, а также первичных документов.
// Для прочих расходов расшифровка по кор. счетам не производится.
// Для прямых расходов расшифровка по кор. счетам производится в случае, 
// если они поступили со счетов прямых расходов, см. ТребуетсяРасшифровкаПоКорСчетам
// Кроме того, если эти расходы были закрыты на счет себестоимости в полном объеме (без распределения),
// то для них на первом уровне (вариант РасходыПоСтатьямЗатрат) 
// производится разузлование до статей затрат, т.е. в отчет выводится аналитика по счетам прямых расходов
//
#Область ПрограммныйИнтерфейс

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасходыПоСтатьямЗатрат");
	НастройкиВарианта.Описание = НСтр("ru = 'Расходы по статьям затрат.'");
	НастройкиВарианта.Размещение.Вставить(Метаданные.Подсистемы.БухгалтерияПредприятияПодсистемы, "");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасшифровкаПоказателей");
	НастройкиВарианта.Описание = НСтр("ru = 'Расходы по статьям затрат (Расшифровка).'");
	НастройкиВарианта.Размещение.Вставить(Метаданные.Подсистемы.БухгалтерияПредприятияПодсистемы, "");
	
КонецПроцедуры

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",          Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",           Ложь);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",           Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",               Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
	Результат.Вставить("ИспользоватьПриВыводеЗаголовка",              Истина);
	Результат.Вставить("ИспользоватьПриВыводеПодвала",                Ложь);
	
	Возврат Результат;
	
КонецФункции

// Формирует текст, выводимый в заголовке отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//
// Возвращаемое значение:
//   Строка      - текст заголовка с учетом периода.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	ЧастиЗаголовка = Новый Массив;
	ЧастиЗаголовка.Добавить(ПараметрыОтчета.ЗаголовокОтчета);
	ЧастиЗаголовка.Добавить(БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода));
	
	Возврат СтрСоединить(ЧастиЗаголовка);
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Организация",  ПараметрыОтчета.Организация);
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "ПоКорСчетам", ПараметрыОтчета.ПоКорСчетам);
		
	ЭтоРасшифровкаПрямыхЗатрат = (ПараметрыОтчета.Счета = ПланыСчетов.Хозрасчетный.СебестоимостьПродаж);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "ЭтоПрямыеЗатраты", ЭтоРасшифровкаПрямыхЗатрат);
		
	СчетаПрямыхЗатратГруппы = УчетЗатрат.ПредопределенныеСчетаПрямыхРасходов();
	СчетаПрямыхЗатрат = УчетЗатрат.СчетаРасходов(СчетаПрямыхЗатратГруппы);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "СчетаПрямыхЗатрат", СчетаПрямыхЗатрат);
	
	МассивСубконто = Новый Массив;
	МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.НоменклатурныеГруппы);
	МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, "СубконтоПрямыхЗатрат", МассивСубконто);
		
	Если Не ПолучитьФункциональнуюОпцию("ИспользуетсяЕНВД") Или ПолучитьФункциональнуюОпцию("ИспользуетсяУСНПатент") Тогда
		
		ТекстПоляВидДеятельностиДляНалоговогоУчетаЗатрат =
		"ВЫБОР
		|		КОГДА ХозрасчетныйОбороты.КорСубконто1 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.КорСубконто1 КАК Справочник.СтатьиЗатрат).ВидДеятельностиДляНалоговогоУчетаЗатрат
		|		КОГДА ХозрасчетныйОбороты.КорСубконто2 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.КорСубконто2 КАК Справочник.СтатьиЗатрат).ВидДеятельностиДляНалоговогоУчетаЗатрат
		|		КОГДА ХозрасчетныйОбороты.КорСубконто3 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ВЫРАЗИТЬ(ХозрасчетныйОбороты.КорСубконто3 КАК Справочник.СтатьиЗатрат).ВидДеятельностиДляНалоговогоУчетаЗатрат
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ПустаяСсылка)
		|	КОНЕЦ";
		
	Иначе
		
		ТекстПоляВидДеятельностиДляНалоговогоУчетаЗатрат =
		"ВЫБОР
		|		КОГДА ХозрасчетныйОбороты.КорСубконто1 ССЫЛКА Справочник.СтатьиЗатрат
		|				ИЛИ ХозрасчетныйОбороты.КорСубконто2 ССЫЛКА Справочник.СтатьиЗатрат
		|				ИЛИ ХозрасчетныйОбороты.КорСубконто3 ССЫЛКА Справочник.СтатьиЗатрат
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ПустаяСсылка)
		|	КОНЕЦ";
		
	КонецЕсли;
	Схема.НаборыДанных.РасходыПоСтатьямЗатрат.Запрос = СтрЗаменить(
		Схема.НаборыДанных.РасходыПоСтатьямЗатрат.Запрос,
		"&ТекстПоляВидДеятельностиДляНалоговогоУчетаЗатрат",
		ТекстПоляВидДеятельностиДляНалоговогоУчетаЗатрат);
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	Счета = СчетаВИерархии(ПараметрыОтчета.Счета);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Счета", Счета);
		
	Если ПараметрыОтчета.ЭтоРасшифровкаНормируемыхРасходов Тогда
		
		Настройки = КомпоновщикНастроек.Настройки;
		
		// Период
		ГруппировкаПоПериоду = Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ПолеГруппировки = ГруппировкаПоПериоду.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Период");
		
		ВыбранноеПолеПериод = ГруппировкаПоПериоду.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеПериод.Поле = Новый ПолеКомпоновкиДанных("Период");
		ВыбранноеПолеПериод.Заголовок = "Период";
		
		ВыбранноеПолеСумма = ГруппировкаПоПериоду.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеСумма.Поле = Новый ПолеКомпоновкиДанных("Сумма");
		
		КрайняяГруппировка = ГруппировкаПоПериоду;
		
		// Организации
		ЕстьФилиалы = (Справочники.Организации.ВсяОрганизация(
			ПараметрыОтчета.Организация, НачалоДня(ПараметрыОтчета.НачалоПериода)).Количество() > 1);
		
		Если ЕстьФилиалы Тогда
			ГруппировкаОрганизация = ГруппировкаПоПериоду.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ПолеГруппировки = ГруппировкаОрганизация.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Организация");

			ВыбранноеПолеВидРасходов = ГруппировкаОрганизация.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПолеВидРасходов.Поле = Новый ПолеКомпоновкиДанных("Организация");
			ВыбранноеПолеВидРасходов.Заголовок = НСтр("ru = 'Организация'");

			ВыбранноеПолеСумма = ГруппировкаОрганизация.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПолеСумма.Поле = Новый ПолеКомпоновкиДанных("Сумма");
			КрайняяГруппировка = ГруппировкаОрганизация;
		КонецЕсли;
		
		// Вид расходов
		ГруппировкаВидРасходов = КрайняяГруппировка.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ПолеГруппировки = ГруппировкаВидРасходов.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ПолеГруппировки1");
		
		ВыбранноеПолеВидРасходов = ГруппировкаВидРасходов.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеВидРасходов.Поле = Новый ПолеКомпоновкиДанных("ПолеГруппировки1");
		ВыбранноеПолеВидРасходов.Заголовок = НСтр("ru = 'Вид расходов'");
		
		ВыбранноеПолеСумма = ГруппировкаВидРасходов.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеСумма.Поле = Новый ПолеКомпоновкиДанных("Сумма");

		// Статья затрат
		ГруппировкаСтатьяЗатрат = ГруппировкаВидРасходов.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ПолеГруппировки = ГруппировкаСтатьяЗатрат.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ПолеГруппировки2");
		
		ВыбранноеПолеВидРасходов = ГруппировкаСтатьяЗатрат.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеВидРасходов.Поле = Новый ПолеКомпоновкиДанных("ПолеГруппировки2");
		ВыбранноеПолеВидРасходов.Заголовок = НСтр("ru = 'Статья затрат'");
		
		ВыбранноеПолеСумма = ГруппировкаСтатьяЗатрат.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПолеСумма.Поле = Новый ПолеКомпоновкиДанных("Сумма");
		
		// Отключение группировок, установленных в макете СКД
		БухгалтерскиеОтчетыКлиентСервер.НайтиГруппировку(
			КомпоновщикНастроек.Настройки.Структура, "НоменклатурнаяГруппа").Использование = Ложь;
		БухгалтерскиеОтчетыКлиентСервер.НайтиГруппировку(
			КомпоновщикНастроек.Настройки.Структура, "ПолеГруппировки1").Использование = Ложь;
		
		КомпоновщикНастроек.Настройки.Порядок.Элементы.Очистить();
		ПолеСортировки = КомпоновщикНастроек.Настройки.Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
		ПолеСортировки.Поле = Новый ПолеКомпоновкиДанных("Период");
		
	ИначеЕсли Не ПараметрыОтчета.РежимРасшифровки Тогда
		
		Если ПараметрыОтчета.Счета <> ПланыСчетов.Хозрасчетный.СебестоимостьПродаж Тогда
			НеиспользуемаяГруппировка = БухгалтерскиеОтчетыКлиентСервер.НайтиГруппировку(
				КомпоновщикНастроек.Настройки.Структура, "НоменклатурнаяГруппа");
		Иначе
			НеиспользуемаяГруппировка = БухгалтерскиеОтчетыКлиентСервер.НайтиГруппировку(
				КомпоновщикНастроек.Настройки.Структура, "ПолеГруппировки1");
		КонецЕсли;
			
		НеиспользуемаяГруппировка.Использование = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события подсистемы БухгалтерскиеОтчеты.
// Вызов определяется параметром ИспользоватьПриВыводеЗаголовка.
//
// Параметры:
//  ПараметрыОтчета		 - Структура - контекст, в котором формируется отчет.
//                         См. СправкиРасчеты.КонтекстФормированияОтчета.
//  КомпоновщикНастроек	 - КомпоновщикНастроекКомпоновкиДанных - описание связи настроек и схемы отчета.
//  Результат - ТабличныйДокумент - табличный документ с сформированным отчетом.
//
Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	// Организация
	Если ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, 
			ПараметрыОтчета.ВключатьОбособленныеПодразделения, ПараметрыОтчета.КонецПериода);
		ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
		Результат.Вывести(ОбластьОрганизация);
	КонецЕсли;
	
	// Текст заголовка
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = ПолучитьТекстЗаголовка(ПараметрыОтчета);
	Результат.Вывести(ОбластьЗаголовок);
	
	Если ПараметрыОтчета.ЭтоРасшифровкаНормируемыхРасходов Тогда
		ТекстОтбор = Строка(КомпоновщикНастроек.Настройки.Отбор);
		
		Если Не ПустаяСтрока(ТекстОтбор) Тогда
			ОбластьОписаниеНастроек = Макет.ПолучитьОбласть("ОписаниеНастроек");
			ОбластьОписаниеНастроек.Параметры.ИмяНастроекОтчета      = НСтр("ru = 'Отбор:'");
			ОбластьОписаниеНастроек.Параметры.ОписаниеНастроекОтчета = ТекстОтбор;
			Результат.Вывести(ОбластьОписаниеНастроек);
		КонецЕсли;
		
	ИначеЕсли ПараметрыОтчета.Свойство("ТекстВыводимыеДанные") Тогда
		ОбластьОписаниеНастроек.Параметры.ИмяНастроекОтчета      = НСтр("ru = 'Выводимые данные:'");
		ОбластьОписаниеНастроек.Параметры.ОписаниеНастроекОтчета = ПараметрыОтчета.ТекстВыводимыеДанные;
		Результат.Вывести(ОбластьОписаниеНастроек);
	КонецЕсли;
			
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
КонецПроцедуры

// Заполняет настройки расшифровки
//
// Параметры:
//  Адрес					- Строка - адрес с данными отчета во временном хранилище.
//  Расшифровка 			- ИдентификаторРасшифровкиКомпоновкиДанных - идентификатор расшифровки из ячейки для которой вызвана расшифровка.
//  ПараметрыРасшифровки	- Структура - настройки расшифровки отчета, которые нужно заполнить.
//
Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеОтборы = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ПользовательскиеОтборы.ИдентификаторПользовательскойНастройки = "Отбор";
	
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
	
	ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
	ДополнительныеСвойства.Вставить("Организация"     , ОтчетОбъект.Организация);

	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровки.Настройки);
	КомпоновщикНастроек.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));
	
	СоответствиеПолей = Новый Соответствие;
	СоответствиеПолей.Вставить("ПолеГруппировки1");
	СоответствиеПолей.Вставить("ПолеГруппировки2");
	СоответствиеПолей.Вставить("КорСчетСсылка");
	СоответствиеПолей.Вставить("НоменклатурнаяГруппа");
	СоответствиеПолей.Вставить("Период");
	СоответствиеПолей.Вставить("Организация");
	
	РазобранныеДанныеРасшифровки = БухгалтерскиеОтчеты.ПолучитьДанныеРасшифровки(
		ДанныеРасшифровки, СоответствиеПолей, Расшифровка);
	
	// Пока отчет поддерживает расшифровку только этих полей
	МассивРасшифровываемыхПолей = СтрРазделить("Сумма", ",");
	
	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(
		Расшифровка, ДанныеРасшифровки, КомпоновщикНастроек, Истина);
		
	Для Каждого Отбор Из МассивПолей Цикл
			
		Если ТипЗнч(Отбор) <> Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если МассивРасшифровываемыхПолей.Найти(Отбор.Поле) <> Неопределено Тогда
			ДобавитьПараметрыРасшифровки(Отбор.Поле, ОтчетОбъект, РазобранныеДанныеРасшифровки, ПараметрыРасшифровки);
			Прервать;
		ИначеЕсли Отбор.Значение = NULL Тогда
			Прервать;
		Иначе
			Если ЗначениеЗаполнено(Отбор.Значение) Тогда
				ПараметрыРасшифровки.Вставить("Значение",      Отбор.Значение);
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Возвращает набор показателей отчета.
// Возвращаемое значение:
//   НаборПоказателей - Массив.
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	
	Возврат НаборПоказателей;
	
КонецФункции

// Адаптирует переданные настройки для данного вида отчетов.
// Перед применением настроек расшифровки может возникнуть необходимость учесть особенности этого вида отчетов.
//
// Параметры:
//  Настройки	 - Структура - Настройки которые нужно адаптировать (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//
Процедура АдаптироватьНастройки(Настройки) Экспорт
	
	// Удалим автоотступ из условного оформления.
	БухгалтерскиеОтчеты.УдалитьАвтоотступИзУсловногоОформления(Настройки.УсловноеОформление);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТребуетсяРасшифровкаПоКорСчетам(Счет, КорСчет = Неопределено, ЗначениеОтбора = Неопределено)
	
	Если Счет = ПланыСчетов.Хозрасчетный.ПрочиеРасходы Тогда
		// Для прочих расходов не требуется разузлование по кор. счетам, с которых они поступили
		// Например, расходы на услуги банков в общем случае приходят сразу с 51 счета
		Возврат Ложь;
		
	ИначеЕсли Счет = ПланыСчетов.Хозрасчетный.СебестоимостьПродаж Тогда
		// Для прямых расходов разузлование по кор. счетам требуется в случае,
		// если расходы поступили со счетов прямых затрат
		Если КорСчет <> Неопределено Тогда
			СчетаПрямыхРасходовГруппы = УчетЗатрат.ПредопределенныеСчетаПрямыхРасходов();
			СчетаПрямыхРасходов = УчетЗатрат.СчетаРасходов(СчетаПрямыхРасходовГруппы);
			Возврат СчетаПрямыхРасходов.Найти(КорСчет) <> Неопределено;
			
		ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("ПеречислениеСсылка.ВидыРасходовНУ") Тогда
			
			Возврат Истина;
		КонецЕсли;
		
		Возврат Ложь;
		
	Иначе
		
		// Для косвенных расходов разузлование по кор. счетам требуется всегда
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

Процедура ДобавитьПараметрыРасшифровки(ИмяПоля, ОтчетОбъект, РазобранныеДанныеРасшифровки, ПараметрыРасшифровки)
	
	Если ИмяПоля <> "Сумма" Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьДанныеРасшифровки = Ложь;
	Для Каждого КлючЗначениеРасшифровки Из РазобранныеДанныеРасшифровки Цикл
		Если ЗначениеЗаполнено(КлючЗначениеРасшифровки.Значение) Тогда
			ЕстьДанныеРасшифровки = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьДанныеРасшифровки Тогда
		Возврат;
	КонецЕсли;
	
	УниверсальныеНастройки = БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки();
	ЗаполнитьЗначенияСвойств(УниверсальныеНастройки, ОтчетОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация",            ОтчетОбъект.Организация);
	ПараметрыФормы.Вставить("Счета",                  ОтчетОбъект.Счета);
	ПараметрыФормы.Вставить("НаименованиеПоказателя", ОтчетОбъект.НаименованиеПоказателя);
	ПараметрыФормы.Вставить("НаименованиеСтроки",     ОтчетОбъект.НаименованиеСтроки);
	ПараметрыФормы.Вставить("РежимРасшифровки",       Истина);
	ПараметрыФормы.Вставить("ОткрытьРасшифровку",     Истина);
	
	ПериодРасшифровки = ОтчетОбъект.НачалоПериода;
	
	ИмяФормы = "Отчет.РасходыПоСтатьямЗатрат.ФормаОбъекта";
	УниверсальныеНастройки.КлючВарианта = "РасшифровкаПоказателей";
	
	ПараметрыФормы.Вставить("ЗначениеОтбора1", РазобранныеДанныеРасшифровки["ПолеГруппировки1"]);
	ПараметрыФормы.Вставить("ЗначениеОтбора2", РазобранныеДанныеРасшифровки["ПолеГруппировки2"]);
	
	ТребуетсяРасшифровкаПоКорСчетам = Не ОтчетОбъект.ЭтоРасшифровкаНормируемыхРасходов И ТребуетсяРасшифровкаПоКорСчетам(
		ОтчетОбъект.Счета,
		РазобранныеДанныеРасшифровки["КорСчетСсылка"],
		РазобранныеДанныеРасшифровки["ПолеГруппировки1"]);
	ПараметрыФормы.Вставить("ПоКорСчетам", ТребуетсяРасшифровкаПоКорСчетам);
	
	ИмяПоляОтбора = ИмяПоляОтбораРасшифровки(РазобранныеДанныеРасшифровки["ПолеГруппировки1"]);
	
	Если ИмяПоляОтбора <> Неопределено Тогда
		ДобавитьОтборВРасшифровку(
			УниверсальныеНастройки.НастройкиКомпоновки,
			РазобранныеДанныеРасшифровки,
			"ПолеГруппировки1",
			ИмяПоляОтбора);
	КонецЕсли;
	
	ИмяПоляОтбора = ИмяПоляОтбораРасшифровки(РазобранныеДанныеРасшифровки["ПолеГруппировки2"]);
	
	Если ИмяПоляОтбора <> Неопределено Тогда
		ДобавитьОтборВРасшифровку(
			УниверсальныеНастройки.НастройкиКомпоновки,
			РазобранныеДанныеРасшифровки,
			"ПолеГруппировки2",
			ИмяПоляОтбора);
	КонецЕсли;
		
	ДобавитьОтборВРасшифровку(
		УниверсальныеНастройки.НастройкиКомпоновки,
		РазобранныеДанныеРасшифровки,
		"КорСчетСсылка",
		"КорСчетРасшифровки");
		
	ДобавитьОтборВРасшифровку(
		УниверсальныеНастройки.НастройкиКомпоновки,
		РазобранныеДанныеРасшифровки,
		"НоменклатурнаяГруппа",
		"НоменклатурнаяГруппаРасшифровки");
		
	Если ОтчетОбъект.Свойство("ЭтоРасшифровкаНормируемыхРасходов") И ОтчетОбъект.ЭтоРасшифровкаНормируемыхРасходов
		И РазобранныеДанныеРасшифровки["Период"] <> Неопределено Тогда
		
		УниверсальныеНастройки.Вставить("НачалоПериода", НачалоМесяца(РазобранныеДанныеРасшифровки["Период"]));
		УниверсальныеНастройки.Вставить("КонецПериода", КонецМесяца(РазобранныеДанныеРасшифровки["Период"]));
		
		ДобавитьОтборВРасшифровку(
			УниверсальныеНастройки.НастройкиКомпоновки,
			РазобранныеДанныеРасшифровки,
			"Организация",
			"Организация");
			
		Если ЗначениеЗаполнено(РазобранныеДанныеРасшифровки["Организация"]) Тогда
			УниверсальныеНастройки.Организация = РазобранныеДанныеРасшифровки["Организация"];
			ПараметрыФормы.Организация = РазобранныеДанныеРасшифровки["Организация"];
		КонецЕсли;
		
		ЗначениеОтбора1 = ПараметрыФормы.ЗначениеОтбора1;
		// Скопируем отборы исходного отчета в расшифровку.
		Для Каждого ЭлементОтбора Из ОтчетОбъект.НастройкиКомпоновкиДанных.Отбор.Элементы Цикл
			Поле = ИмяПоляОтбораРасшифровки(ЭлементОтбора.ПравоеЗначение);
			Если ЗначениеЗаполнено(Поле) Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
					УниверсальныеНастройки.НастройкиКомпоновки,
					Поле,
					ЭлементОтбора.ПравоеЗначение,
					ЭлементОтбора.ВидСравнения);
				ЗначениеОтбора1 = ЭлементОтбора.ПравоеЗначение;
			КонецЕсли;
		КонецЦикла;
			
		Если Не ЗначениеЗаполнено(ПараметрыФормы.ЗначениеОтбора1) Тогда
			ПараметрыФормы.ЗначениеОтбора1 = ЗначениеОтбора1;
		КонецЕсли;
	Иначе
		УниверсальныеНастройки.Вставить("НачалоПериода", ПериодРасшифровки);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("УниверсальныеНастройки",  УниверсальныеНастройки);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект",  Ложь);
	ПараметрыРасшифровки.Вставить("ОткрытьФорму",   Истина);
	ПараметрыРасшифровки.Вставить("Форма",          ИмяФормы);
	ПараметрыРасшифровки.Вставить("ПараметрыФормы", ПараметрыФормы);
	
КонецПроцедуры

Функция ИмяПоляОтбораРасшифровки(ЗначениеОтбора)
	
	Если ТипЗнч(ЗначениеОтбора) = Тип("ПеречислениеСсылка.ВидыПрочихДоходовИРасходов") Тогда
		Возврат "ВидПрочихДоходовИРасходовРасшифровки";
		
	ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("ПеречислениеСсылка.ВидыРасходовНУ") Тогда
		Возврат "ВидРасходовНУРасшифровки";
		
	ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат "Контрагент";
		
	ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("СправочникСсылка.РегистрацииВНалоговомОргане") Тогда
		Возврат "РегистрацияВНалоговомОрганеРасшифровки";
		
	ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("СправочникСсылка.СтатьиЗатрат") Тогда
		Возврат "СтатьяЗатратРасшифровки"
		
	ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("СправочникСсылка.ПрочиеДоходыИРасходы") Тогда
		Возврат "ПрочиеДоходыИРасходыРасшифровки"
		
	ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("СправочникСсылка.Номенклатура") Тогда
		Возврат "НоменклатураРасшифровки";
		
	ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		Возврат "ФизическоеЛицо";
		
	ИначеЕсли ТипЗнч(ЗначениеОтбора) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
		Возврат "БанковскийСчет";

	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ДобавитьОтборВРасшифровку(НастройкиКомпоновки, РазобранныеДанныеРасшифровки, ПолеРасшифровки, ПолеКомпоновки)
	
	ДобавлятьОтбор = Истина;
	
	Если ЗначениеЗаполнено(РазобранныеДанныеРасшифровки[ПолеРасшифровки]) Тогда
		ЗначениеРасшифровки = РазобранныеДанныеРасшифровки[ПолеРасшифровки];
		ВидСравненияРасшифровки = ВидСравненияКомпоновкиДанных.Равно;
		
	ИначеЕсли РазобранныеДанныеРасшифровки[ПолеРасшифровки] <> Неопределено Тогда
		ЗначениеРасшифровки = Неопределено;
		ВидСравненияРасшифровки = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		
	Иначе
		ДобавлятьОтбор = Ложь;
	КонецЕсли;
	
	Если ДобавлятьОтбор Тогда
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(
			НастройкиКомпоновки,
			ПолеКомпоновки,
			ЗначениеРасшифровки,
			ВидСравненияРасшифровки);
	КонецЕсли;
	
КонецПроцедуры

// Счета в иерархии.
// 
// Параметры:
//  Счета - СписокЗначений из ПланСчетовСсылка.Хозрасчетный
//        - ПланСчетовСсылка.Хозрасчетный
// 
// Возвращаемое значение:
//  Массив из ПланСчетовСсылка.Хозрасчетный - Счета, входящие в иерархию счета или списка счетов, указанных в параметре.
//
Функция СчетаВИерархии(Счета)

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Хозрасчетный.Ссылка КАК Счет
		|ИЗ
		|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
		|ГДЕ
		|	Хозрасчетный.Ссылка В ИЕРАРХИИ (&Счета)";
	
	Запрос.УстановитьПараметр("Счета", Счета);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Счет");

КонецФункции

#КонецОбласти

#КонецЕсли
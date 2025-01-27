﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета",          Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",           Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",               Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
	
	Возврат Результат;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, 
		"Организация", 
		ПараметрыОтчета.Организация);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, 
		"НачалоПериода", 
		НачалоДня(ПараметрыОтчета.НачалоПериода));
	
	КонецПериода = ?(ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода), 
		КонецДня(ПараметрыОтчета.КонецПериода), 
		'39990101');
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек, 
		"КонецПериода", 
		КонецПериода);
	
	ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"РуководительДолжность",
		ОтветственныеЛица.РуководительДолжность);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"РуководительПредставление",
		ОтветственныеЛица.РуководительПредставление);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
		КомпоновщикНастроек,
		"ТекущаяДата",
		ОбщегоНазначенияБП.ТекущаяДатаНаСервере());
	
	ПростойУчетЕНС = ПараметрыОтчета.НачалоПериода >= ЕдиныйНалоговыйСчет.НачалоПростогоУчета();
	
	Если ПараметрыОтчета.ВариантОтчета = "РасчетыПоЕНС"
		И Не ПростойУчетЕНС Тогда
		
		ИмяОтчетаРасчетыПоНалогам = НСтр("ru='Расшифровка расчетов налогов по ЕНС'");
		ПериодОтчета = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
		ОстатокПоЕНСНаНачалоПериода = ЕдиныйНалоговыйСчет.ОстатокНаЕдиномНалоговомСчете(
			ПараметрыОтчета.Организация, ПараметрыОтчета.НачалоПериода);
		ОстатокПоЕНСНаКонецПериода = ЕдиныйНалоговыйСчет.ОстатокНаЕдиномНалоговомСчете(
			ПараметрыОтчета.Организация, ПараметрыОтчета.КонецПериода);
		
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, 
			"ПериодОтчета", 
			ПериодОтчета);
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, 
			"ОстатокПоЕНСНаНачалоПериода", 
			Формат(ОстатокПоЕНСНаНачалоПериода, "ЧДЦ=2; ЧН=0,00"));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, 
			"ОстатокПоЕНСНаКонецПериода", 
			Формат(ОстатокПоЕНСНаКонецПериода, "ЧДЦ=2; ЧН=0,00"));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, 
			"ИмяОтчетаРасчетыПоНалогам", 
			ИмяОтчетаРасчетыПоНалогам);
		
	КонецЕсли;
	
	Если ПараметрыОтчета.ВариантОтчета = "РасчетыПоНалогамНаЕНС" 
		И ПростойУчетЕНС Тогда
		
		// Все обслуживаемые счета, кроме 68.10, для него есть отдельный запрос
		СчетаНалоговВзносов = ЕдиныйНалоговыйСчетПовтИсп.ОбслуживаемыеСчетаУчета(ПараметрыОтчета.КонецПериода);
		СчетаНалоговВзносов = ОбщегоНазначенияКлиентСервер.РазностьМассивов(
			СчетаНалоговВзносов,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПланыСчетов.Хозрасчетный.ПрочиеНалогиИСборы));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(
			КомпоновщикНастроек, 
			"СчетаНалоговВзносов", 
			СчетаНалоговВзносов);
		
		ПоказыватьСчетаУчета = СчетаУчетаВДокументахВызовСервераПовтИсп.ПользовательУправляетСчетамиУчета();
		Если Не ПоказыватьСчетаУчета Тогда
			СтруктураОтчета = КомпоновщикНастроек.Настройки.Структура;
			ГруппировкаНалог = БухгалтерскиеОтчеты.НайтиПоИмени(СтруктураОтчета, "Налог");
			ОтключаемыеПоля = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый ПолеКомпоновкиДанных("СчетНалога"));
			ОтключитьПоля(ГруппировкаНалог, ОтключаемыеПоля);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Адрес);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
	
	ЭлементРасшифровки = ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЭлементРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхГруппировка") Тогда
		Возврат;
	КонецЕсли;
	
	ПоляРасшифровки = ЭлементРасшифровки.ПолучитьПоля();
	Если ПоляРасшифровки.Количество() > 0 Тогда
		Если ПоляРасшифровки[0].Значение = Null Тогда
			Возврат;
		ИначеЕсли ПоляРасшифровки[0].Поле = "Налог" Тогда
			Если ПоляРасшифровки[0].Значение = Справочники.ВидыНалоговИПлатежейВБюджет.ЕдиныйНалоговыйПлатеж Тогда
				
				СписокПунктовМеню = Новый СписокЗначений();
				СписокПунктовМеню.Добавить("РасшифровкаЗачетаАвансовНаЕНС", "РасшифровкаЗачетаАвансовНаЕНС");
				
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект",     Ложь);
				ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
				ПараметрыРасшифровки.Вставить("ОткрытьФорму",      Истина);
				ПараметрыРасшифровки.Вставить("Форма",             "Отчет.СправкаРасчетЗачетАвансаПоЕдиномуНалоговомуСчету.ФормаОбъекта");
				
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("КлючВарианта",      "РасшифровкаЗачетаАвансовНаЕНС");
				ПараметрыФормы.Вставить("НачалоПериода",     ОтчетОбъект.НачалоПериода);
				ПараметрыФормы.Вставить("КонецПериода",      ОтчетОбъект.КонецПериода);
				ПараметрыФормы.Вставить("Организация",       ОтчетОбъект.Организация);
				ПараметрыФормы.Вставить("РежимРасшифровки",  Истина);
				ПараметрыФормы.Вставить("Налог",             Неопределено);
				ПараметрыФормы.Вставить("ПлатежныйДокумент", ПоляРасшифровки[1].Значение);
				ПараметрыФормы.Вставить("СрокУплаты",        Неопределено);
				
				ПараметрыРасшифровки.Вставить("ПараметрыФормы", ПараметрыФормы);
				
			Иначе
				
				СписокПунктовМеню = Новый СписокЗначений();
				СписокПунктовМеню.Добавить("РасшифровкаРасчетовНалоговПоЕНС", "РасшифровкаРасчетовНалоговПоЕНС");
				
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект",     Ложь);
				ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
				ПараметрыРасшифровки.Вставить("ОткрытьФорму",      Истина);
				ПараметрыРасшифровки.Вставить("Форма",             "Отчет.СправкаРасчетЗачетАвансаПоЕдиномуНалоговомуСчету.ФормаОбъекта");
				
				ПараметрыФормы = Новый Структура;
				ПараметрыФормы.Вставить("КлючВарианта",      "РасшифровкаРасчетовНалоговПоЕНС");
				ПараметрыФормы.Вставить("НачалоПериода",     ОтчетОбъект.НачалоПериода);
				ПараметрыФормы.Вставить("КонецПериода",      ОтчетОбъект.КонецПериода);
				ПараметрыФормы.Вставить("Организация",       ОтчетОбъект.Организация);
				ПараметрыФормы.Вставить("Налог",             ПоляРасшифровки[0].Значение);
				ПараметрыФормы.Вставить("ПлатежныйДокумент", Неопределено);
				ПараметрыФормы.Вставить("СрокУплаты",        ПоляРасшифровки[2].Значение);
				ПараметрыФормы.Вставить("РежимРасшифровки",  Истина);
				
				ПараметрыРасшифровки.Вставить("ПараметрыФормы", ПараметрыФормы);
				
			КонецЕсли;
		Иначе
			ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
			ПараметрыРасшифровки.Вставить("Значение",      ПоляРасшифровки[0].Значение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиБухгалтерскиеОтчеты

Функция ПолучитьТекстЗаголовка(Контекст) Экспорт
	
	Если Контекст.ВариантОтчета = "РасчетыПоНалогамНаЕНС" Тогда
		Название = НСтр("ru='Расчеты по налогам на ЕНС'");
	Иначе
		Название = НСтр("ru='Расчеты по ЕНС'");
	КонецЕсли;
	
	ЗаПериод = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		Контекст.НачалоПериода, 
		Контекст.КонецПериода);
	
	ЗаголовокОтчета = Название + ЗаПериод;
	Возврат ЗаголовокОтчета;
	
КонецФункции

Процедура ПослеВыводаРезультата(Контекст, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(Контекст.ИдентификаторОтчета, Результат);
	Результат.ФиксацияСверху = ВысотаЗаголовка(Контекст, Результат);
	
КонецПроцедуры

#КонецОбласти

Функция ОписаниеНалога(Налог, КодБК, КодПоОКТМО, РегистрацияВНалоговомОргане) Экспорт
	
	ОписаниеНалога = Новый Массив;
	
	Если Налог = Справочники.ВидыНалоговИПлатежейВБюджет.ЕдиныйНалоговыйПлатеж Тогда
		ОписаниеНалога.Добавить("КБК");
		ОписаниеНалога.Добавить(" ");
		ОписаниеНалога.Добавить(Строка(Справочники.ВидыНалоговИПлатежейВБюджет.КБК(Справочники.ВидыНалоговИПлатежейВБюджет.ЕдиныйНалоговыйПлатеж)));
		Возврат Новый ФорматированнаяСтрока(ОписаниеНалога);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодБК) Тогда
		ОписаниеНалога.Добавить("КБК");
		ОписаниеНалога.Добавить(" ");
		ОписаниеНалога.Добавить(Строка(КодБК));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане) Тогда
		ОписаниеНалога.Добавить(Символы.ПС);
		ОписаниеНалога.Добавить(Строка(РегистрацияВНалоговомОргане));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодПоОКТМО) Тогда
		ОписаниеНалога.Добавить(Символы.ПС);
		ОписаниеНалога.Добавить("ОКТМО");
		ОписаниеНалога.Добавить(" ");
		ОписаниеНалога.Добавить(Строка(КодПоОКТМО))
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(ОписаниеНалога);
	
КонецФункции

Функция ВысотаЗаголовка(Контекст, Результат)
	
	ВысотаЗаголовка = 0;
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(Контекст.ДанныеРасшифровки);
	
	Если Не ЗначениеЗаполнено(ДанныеОбъекта) Тогда
		Возврат ВысотаЗаголовка;
	КонецЕсли;
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровки = ДанныеОбъекта.ДанныеРасшифровки;
	
	// Начинаем перебирать первые ячейки таблицы, и если в ячейке обнаружится расшифровка,
	// то значит начались строки таблицы, их фиксировать уже не надо.
	Для НомерСтроки = 1 По Результат.ВысотаТаблицы Цикл
		
		Ячейка = Результат.Область(НомерСтроки, 1, НомерСтроки, 1);
		
		Если Ячейка.Расшифровка = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Расшифровка = ДанныеОбъекта.ДанныеРасшифровки.Элементы[Ячейка.Расшифровка];
		ПоляРасшифровки = Расшифровка.ПолучитьПоля();
		Если ПоляРасшифровки.Количество() > 0 Тогда
			Если ПоляРасшифровки[0].Значение = Null Тогда
				Продолжить;
			Иначе
				ВысотаЗаголовка = НомерСтроки - 1;
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ВысотаЗаголовка;
	
КонецФункции

Процедура ОтключитьПоля(Группировка, ОтключаемыеПоля)
	
	Если Группировка = Неопределено 
		Или Не ЗначениеЗаполнено(ОтключаемыеПоля) Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Элемент Из Группировка.Выбор.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ВыбранноеПолеКомпоновкиДанных") 
			И ОтключаемыеПоля.Найти(Элемент.Поле) <> Неопределено Тогда
			Элемент.Использование = Ложь;
		ИначеЕсли ТипЗнч(Элемент) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			ОтключитьПоля(Элемент, ОтключаемыеПоля);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПредставлениеНалога(СчетУчета, Налог) Экспорт
	
	Если СчетУчета = ПланыСчетов.Хозрасчетный.РасчетыСБюджетом Тогда // 68.04.1
		Возврат НСтр("ru='Налог на прибыль'")
	ИначеЕсли СчетУчета = ПланыСчетов.Хозрасчетный.ПрочиеНалогиИСборы // 68.10
		И ЗначениеЗаполнено(Налог) Тогда
		Возврат Строка(Налог);
	ИначеЕсли ЗначениеЗаполнено(СчетУчета) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СчетУчета, "Наименование");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции


#КонецОбласти

#КонецЕсли

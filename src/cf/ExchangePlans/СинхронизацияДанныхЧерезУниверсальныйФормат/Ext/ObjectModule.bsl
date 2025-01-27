﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что в расположенным ниже коде,
	// реализована логика, которая должна выполняться в том числе при установке этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный план обмена).
	
	Если ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ЭтоОбмен_УТ_Базовая(ВариантНастройки) Тогда
		ПравилаОтправкиЦен          = "НеСинхронизировать";
		ПравилаОтправкиСправочников = "НеСинхронизировать";
		ПравилаОтправкиДокументов   = "НеСинхронизировать";
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если ВариантНастройки = "ОбменЗУПБП" Тогда
		ПравилаОтправкиЦен          = "НеСинхронизировать";
		УчетЗарплаты.ПроверитьВозможностьИспользованияОбменаЗарплата3Бухгалтерия3ПередЗаписью(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	Если ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСМобильнойКассой() Тогда
		
		ИспользоватьОтборПоСкладам = Истина;
		ОтправлятьНоменклатуру = Истина;
		ОтправлятьСправочники = Истина;
		
		Если Склады.Количество() = 1 Тогда
			СкладПоУмолчанию = Склады[0].Склад;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		РежимВыгрузкиПриНеобходимости   = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		
	Иначе
		
		РежимВыгрузкиПриНеобходимости    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		
		Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
			РежимВыгрузкиСправочников    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		Иначе
			РежимВыгрузкиСправочников    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПравилаОтправкиЦен = "НеСинхронизировать" Тогда
		
		РежимВыгрузкиЦен       = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		
	Иначе
		
		Если ПравилаОтправкиЦен = "СинхронизироватьПоНеобходимости" Тогда
			РежимВыгрузкиЦен = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		Иначе
			РежимВыгрузкиЦен = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
	Иначе
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоСкладам И Склады.Количество() > 0 Тогда
		Склады.Очистить();
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументов = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВерсияФорматаОбмена) Тогда
		ВерсияФорматаОбмена = "1.2";
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСКассой()
		ИЛИ ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСМобильнойКассой() Тогда
		
		ПроверяемыеРеквизиты.Добавить("Склады");
		
		Для каждого СтрокаСклад Из Склады Цикл
			
			Если НЕ ЗначениеЗаполнено(СтрокаСклад.Склад) Тогда
				
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Розничный магазин'"),
					СтрокаСклад.НомерСтроки, "Склады");
				
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Склады", СтрокаСклад.НомерСтроки, "Склад");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, , Отказ);
			КонецЕсли;
		КонецЦикла;
		
		Если Не Отказ Тогда
			// Проверим, что все склады имеют одинаковый тип цен
			Запрос = Новый Запрос();
			Запрос.Параметры.Вставить("Склады", Склады.Выгрузить(, "Склад"));
			Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Склады.ТипЦенРозничнойТорговли
			|ИЗ
			|	Справочник.Склады КАК Склады
			|ГДЕ
			|	Склады.Ссылка В(&Склады)";
			
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Количество() > 1 Тогда
				ТекстСообщения = НСтр("ru = 'У всех выбранных розничных магазинов должен быть указан одинаковый тип цен'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Склады", , Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСМобильнойКассой() Тогда
			
			Если Склады.Количество() > 1 Тогда
				
				ТекстСообщения = НСтр("ru = 'Должен быть указан только один склад'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Склады", , Отказ);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПравилаЗагрузкиПодразделений = "НеЗагружать";
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
	ИспользоватьОтборПоОрганизациям = Ложь;
	ИспользоватьОтборПоСкладам = Ложь;
	
	ДатаНачалаВыгрузкиДокументов = НачалоГода(ТекущаяДата());
	ВыгружатьАналитикуПоСкладам  = Истина;
	
	ВерсияФорматаОбмена = "1.2";
	
	ОтправлятьДокументыПокупкиПродажи = Истина;
	ОтправлятьСкладскиеДокументы = Истина;
	ОтправлятьАвансовыеОтчеты = Истина;
	ОтправлятьСправочники = Истина;
	ОтправлятьНоменклатуру = Истина;
	ОтправлятьБанковскиеДокументы = Истина;
	ОтправлятьКассовыеДокументы = Истина;
	ОтправлятьВедомостиНаВыплатуЗарплаты = Истина;
	
	ПравилаОтправкиЦен = "АвтоматическаяСинхронизация";
	ПравилаОтправкиСправочников = "АвтоматическаяСинхронизация";
	ПравилаОтправкиДокументов = "АвтоматическаяСинхронизация";
	
	Если ЗначениеЗаполнено(ВариантНастройки) Тогда
		НастроитьОтборыПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьОтборыПоУмолчанию()
	
	Если ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСКассой()
		ИЛИ ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСМобильнойКассой() Тогда
		ВерсияФорматаОбмена = "1.8";
	ИначеЕсли ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСУНФ() Тогда
		ВерсияФорматаОбмена = "1.3";
	ИначеЕсли ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСРозницей() Тогда
		ВерсияФорматаОбмена = "1.10";
	ИначеЕсли ВариантНастройки = "ОбменЗУПБП" Тогда
		ВерсияФорматаОбмена = "1.8";
	КонецЕсли;
	
	Если ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСКассой() Тогда
		
		ИспользоватьОтборПоСкладам = Истина;
		
		РозничныеСкладыПоУмолчанию = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.РозничныеСкладыПоУмолчанию();
		
		Для Каждого РозничныйСклад Из РозничныеСкладыПоУмолчанию.Склады Цикл
			Склады.Добавить().Склад = РозничныйСклад;
		КонецЦикла;
		
		ТипЦенДляИзмененияЦен = РозничныеСкладыПоУмолчанию.ТипЦенДляИзмененияЦен;
		
	КонецЕсли;
	
	Если ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСМобильнойКассой() Тогда
		
		ИспользоватьОтборПоСкладам = Истина;
		
		РозничныеСкладыПоУмолчанию = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.РозничныеСкладыПоУмолчанию();
		
		Если РозничныеСкладыПоУмолчанию.Склады.Количество() = 1 Тогда
			Склады.Добавить().Склад = РозничныеСкладыПоУмолчанию.Склады[0];
		КонецЕсли;
		
		ТипЦенДляИзмененияЦен = РозничныеСкладыПоУмолчанию.ТипЦенДляИзмененияЦен;
		
	КонецЕсли;
	
	Если ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ЭтоОбмен_УТ_Базовая(ВариантНастройки) Тогда
		
		ПравилаОтправкиЦен = "НеСинхронизировать";
		ПравилаОтправкиСправочников = "НеСинхронизировать";
		ПравилаОтправкиДокументов = "НеСинхронизировать";
		УстанавливатьПечатьПрефиксаИБДокументов = Истина;
		
	ИначеЕсли ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСКассой()
		ИЛИ ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСМобильнойКассой() Тогда
		
		ПравилаОтправкиЦен = "АвтоматическаяСинхронизация";
		ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости";
		ПравилаОтправкиДокументов = "СинхронизироватьПоНеобходимости";
		
	КонецЕсли;
	
	Если ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ЭтоОбмен_УТ(ВариантНастройки)
		Или ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ЭтоОбмен_УТ_Базовая(ВариантНастройки) Тогда
		ОтправлятьДокументыПокупкиПродажи = Ложь;
		ОтправлятьСкладскиеДокументы = Ложь;
		ОтправлятьАвансовыеОтчеты = Ложь;
		ОтправлятьСправочники = Истина;
		ОтправлятьНоменклатуру = Истина;
		ОтправлятьБанковскиеДокументы = Истина;
		ОтправлятьКассовыеДокументы = Истина;
		ОтправлятьВедомостиНаВыплатуЗарплаты = Ложь;
		УстанавливатьПечатьПрефиксаИБДокументов = Истина;
		ОтправлятьРегламентированныеОтчеты = Ложь;
	ИначеЕсли ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСКассой()
		ИЛИ ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСМобильнойКассой() Тогда
		ОтправлятьДокументыПокупкиПродажи = Ложь;
		ОтправлятьСкладскиеДокументы = Ложь;
		ОтправлятьАвансовыеОтчеты = Ложь;
		ОтправлятьСправочники = Истина;
		ОтправлятьНоменклатуру = Истина;
		ОтправлятьБанковскиеДокументы = Ложь;
		ОтправлятьКассовыеДокументы = Ложь;
		ОтправлятьВедомостиНаВыплатуЗарплаты = Ложь;
		ОтправлятьРегламентированныеОтчеты = Ложь;
	ИначеЕсли ВариантНастройки = "ОбменЗУПБП" Тогда
		ОтправлятьДокументыПокупкиПродажи = Ложь;
		ОтправлятьСкладскиеДокументы = Ложь;
		ОтправлятьАвансовыеОтчеты = Ложь;
		ОтправлятьСправочники = Ложь;
		ОтправлятьНоменклатуру = Ложь;
		ОтправлятьБанковскиеДокументы = Истина;
		ОтправлятьКассовыеДокументы = Истина;
		ОтправлятьВедомостиНаВыплатуЗарплаты = Истина;
		УстанавливатьПечатьПрефиксаИБДокументов = Ложь;
		ОтправлятьРегламентированныеОтчеты = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

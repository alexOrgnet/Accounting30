﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПриказОбОрганизацииВоинскогоУчета") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм,
						"ПФ_MXL_ПриказОбОрганизацииВоинскогоУчета", НСтр("ru = 'Приказ об организации воинского учета'"),
						ПечатнаяФормаПриказаОбОрганизацииВоинскогоУчета(МассивОбъектов, ОбъектыПечати), ,
						"Обработка.ПечатьФормВоинскогоУчета.ПФ_MXL_ПриказОбОрганизацииВоинскогоУчета");
	КонецЕсли;
						
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПланРаботыПоОсуществлениюВоинскогоУчета") Тогда 
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм,
						"ПФ_MXL_ПланРаботыПоОсуществлениюВоинскогоУчета", НСтр("ru = 'План работы по осуществлению воинского учета'"),
						ПечатнаяФормаПланаРаботыПоОсуществлениюВоинскогоУчета(МассивОбъектов, ОбъектыПечати), ,
						"Обработка.ПечатьФормВоинскогоУчета.ПФ_MXL_ПланРаботыПоОсуществлениюВоинскогоУчета");
	КонецЕсли;
	
КонецПроцедуры

#Область ПроцедурыФункцииПечатиБланковВоинскогоУчета

Функция ПечатнаяФормаПриказаОбОрганизацииВоинскогоУчета(МассивОрганизаций, ОбъектыПечати)

	Если Не ЗначениеЗаполнено(МассивОрганизаций) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПриказОбОрганизацииВоинскогоУчета";
	ТабДокумент.Защита = Ложь;
	
	Для Каждого Организация Из МассивОрганизаций Цикл 
		
		ПараметрыЗаполненияПодписантов = ПараметрыПодписантов(Организация);
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьФормВоинскогоУчета.ПФ_MXL_ПриказОбОрганизацииВоинскогоУчета");
		
		ОбластьМакета = Макет.ПолучитьОбласть("Приказ");
		РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "Наименование, НаименованиеПолное");
		ОбластьМакета.Параметры.ПолноеНаименованиеОрганизации = ?(ЗначениеЗаполнено(РеквизитыОрганизации.НаименованиеПолное), РеквизитыОрганизации.НаименованиеПолное, РеквизитыОрганизации.Наименование);
		
		ОбластьМакета.Параметры.Заполнить(ПараметрыЗаполненияПодписантов);
		ТабДокумент.Вывести(ОбластьМакета);
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Организация);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПечатнаяФормаПланаРаботыПоОсуществлениюВоинскогоУчета(МассивОрганизаций, ОбъектыПечати) 

	Если Не ЗначениеЗаполнено(МассивОрганизаций) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПланРаботыПоОсуществлениюВоинскогоУчета";
	ТабДокумент.Защита = Ложь;
	
	Для Каждого Организация Из МассивОрганизаций Цикл 
		
		ПараметрыЗаполненияПодписантов = ПараметрыПодписантов(Организация);
		
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьФормВоинскогоУчета.ПФ_MXL_ПланРаботыПоОсуществлениюВоинскогоУчета");
		
		Страница1 = Макет.ПолучитьОбласть("Страница1");
		Страница2 = Макет.ПолучитьОбласть("Страница2");
		
		РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "Наименование, НаименованиеПолное");
		Страница1.Параметры.ПолноеНаименованиеОрганизации = ?(ЗначениеЗаполнено(РеквизитыОрганизации.НаименованиеПолное), РеквизитыОрганизации.НаименованиеПолное, РеквизитыОрганизации.Наименование);
		
		Страница1.Параметры.Заполнить(ПараметрыЗаполненияПодписантов);
		ТабДокумент.Вывести(Страница1);
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		Страница2.Параметры.Заполнить(ПараметрыЗаполненияПодписантов);
		ТабДокумент.Вывести(Страница2);
		
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, Организация);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ПараметрыПодписантов(Организация)
	
	ПараметрыЗаполнения = Новый Структура("Организация", Организация);
	ПараметрыЗаполнения.Вставить("Руководитель");
	ПараметрыЗаполнения.Вставить("РуководительКадровойСлужбы");
	ПараметрыЗаполнения.Вставить("ДолжностьРуководителяКадровойСлужбыСтрокой");
	ПараметрыЗаполнения.Вставить("ОтветственныйЗаВУР");
	ПараметрыЗаполнения.Вставить("ДолжностьОтветственногоЗаВУРСтрокой");
	
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ПараметрыЗаполнения, ТекущаяДатаСеанса());
	
	МассивОтветственных = Новый Массив;
	
	Если ЗначениеЗаполнено(ПараметрыЗаполнения.Руководитель) Тогда
		МассивОтветственных.Добавить(ПараметрыЗаполнения.Руководитель);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыЗаполнения.РуководительКадровойСлужбы) Тогда
		МассивОтветственных.Добавить(ПараметрыЗаполнения.РуководительКадровойСлужбы);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыЗаполнения.ОтветственныйЗаВУР) Тогда
		МассивОтветственных.Добавить(ПараметрыЗаполнения.ОтветственныйЗаВУР);
	КонецЕсли;
	
	Если МассивОтветственных.Количество() > 0 Тогда
		
		ФИОФизЛиц = ЗарплатаКадры.СоответствиеФИОФизЛицСсылкам(ТекущаяДатаСеанса(), МассивОтветственных);
		
		Если ЗначениеЗаполнено(ПараметрыЗаполнения.Руководитель) Тогда
			ПараметрыЗаполнения.Вставить("РуководительРасшифровкаПодписи",
				ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИОФизЛиц[ПараметрыЗаполнения.Руководитель]));
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ПараметрыЗаполнения.РуководительКадровойСлужбы) Тогда
			
			ФИО = ФИОФизЛиц[ПараметрыЗаполнения.РуководительКадровойСлужбы];
			
			ПараметрыЗаполнения.Вставить("РуководительКадровойСлужбыРасшифровкаПодписи",
				ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИО));
				
			ФИОПолные = ФИО.Фамилия + " " + ФИО.Имя + " " + ФИО.Отчество;
			ФИОПросклоненные = "";
			Если ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ФИОПолные), 3, ФИОПросклоненные, , ПараметрыЗаполнения.РуководительКадровойСлужбы) Тогда
				ФИОПолные = ФИОПросклоненные;
			КонецЕсли;
			
			ПараметрыЗаполнения.Вставить("ФИОРуководительКадровойСлужбы",
				ФИОПолные);
			
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ПараметрыЗаполнения.ОтветственныйЗаВУР) Тогда
			
			ФИО = ФИОФизЛиц[ПараметрыЗаполнения.ОтветственныйЗаВУР];
			
			ПараметрыЗаполнения.Вставить("ОтветственныйЗаВУРРасшифровкаПодписи",
				ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИО));
				
			ФИОПолные = ФИО.Фамилия + " " + ФИО.Имя + " " + ФИО.Отчество;
			ФИОПросклоненные = "";
			Если ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ФИОПолные), 2, ФИОПросклоненные, , ПараметрыЗаполнения.ОтветственныйЗаВУР) Тогда
				ФИОПолные = ФИОПросклоненные;
			КонецЕсли;
			
			ПараметрыЗаполнения.Вставить("ФИООтветственныйЗаВУР",
				ФИОПолные);
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетПокупателю") Тогда
		СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, "СчетПокупателю", "Счет покупателю",
			ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетЗаказ") Тогда
		СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, "СчетЗаказ", "Счет на оплату",
			ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетЗаказКомплект") Тогда
		СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, "СчетЗаказКомплект", "Счет на оплату",
			ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьПечатнуюФорму(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ИмяМакета, СинонимМакета, ОбъектыПечати, ПараметрыВывода)
	
	ТипыОбъектов = ОбщегоНазначенияБП.РазложитьСписокПоТипамОбъектов(МассивОбъектов);
	
	Для каждого ОбъектыТипа Из ТипыОбъектов Цикл
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ОбъектыТипа.Значение[0]);
		
		ДокументыБезСчетовНаОплату = Неопределено;
		СоответствиеСчетовРеализациям = Неопределено;
		ТаблицаСведенийСчетНаОплату = МенеджерОбъекта.ПолучитьТаблицуСведенийСчетаНаОплату(
			ОбъектыТипа.Значение, СоответствиеСчетовРеализациям, ДокументыБезСчетовНаОплату);
		
		Если ЗначениеЗаполнено(ДокументыБезСчетовНаОплату) Тогда 
			Если ПараметрыПечати.Свойство("СокращенноеСообщениеОбОшибке") Тогда
				ВывестиСообщениеНеУказанСчетНаОплату(ДокументыБезСчетовНаОплату, ПараметрыПечати.СокращенноеСообщениеОбОшибке);
			Иначе
				ВывестиСообщениеНеУказанСчетНаОплату(ДокументыБезСчетовНаОплату);
			КонецЕсли;
		КонецЕсли;
		
		// Для правильной печати комплекта, области счетов на оплату должны соотвествовать областям реализации указанным в ОбъектыПечати
		// Для этого подменяем в ОбъектыПечати ссылки на реализации на ссылки на счета, чтобы правильно сработала УправлениеПечатью.ЗадатьОбластьПечатиДокумента()
		// в процедуре ПечатьТорговыхДокументов.ПечатьСчетаНаОплату()
		МассивСчетов = Новый Массив;
		Если СоответствиеСчетовРеализациям <> Неопределено Тогда
			ОбъектыПечатиВрем = Новый СписокЗначений;
			Для каждого ОбъектПечати Из ОбъектыПечати Цикл
				Если СоответствиеСчетовРеализациям[ОбъектПечати.Значение] <> Неопределено Тогда
					Для каждого СчетНаОплатуПоРеализации Из СоответствиеСчетовРеализациям[ОбъектПечати.Значение] Цикл
						ОбъектыПечатиВрем.Добавить(СчетНаОплатуПоРеализации, ОбъектПечати.Представление);
						МассивСчетов.Добавить(СчетНаОплатуПоРеализации);
						
						ПараметрыОтбора = Новый Структура("Документ", СчетНаОплатуПоРеализации);
						
						СтрокиПоСчету = ТаблицаСведенийСчетНаОплату.НайтиСтроки(ПараметрыОтбора);
						Если СтрокиПоСчету.Количество() = 1 Тогда
							СтрокиПоСчету[0].ИмяОбластиПечати = ОбъектПечати.Представление;
						КонецЕсли; 
					КонецЦикла; 
					
					ТаблицаСведенийСчетНаОплату.Сортировать("ИмяОбластиПечати");
				Иначе
					ОбъектыПечатиВрем.Добавить(ОбъектПечати.Значение, ОбъектПечати.Представление);
				КонецЕсли; 
			КонецЦикла; 
		Иначе
			ОбъектыПечатиВрем = ОбщегоНазначенияКлиентСервер.СкопироватьСписокЗначений(ОбъектыПечати);
		КонецЕсли; 
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, ИмяМакета, СинонимМакета, 
			ПечатьТорговыхДокументов.ПечатьСчетаНаОплату(ТаблицаСведенийСчетНаОплату, ОбъектыПечатиВрем, ПараметрыПечати),,"ОбщийМакет.ПФ_MXL_СчетЗаказ");
			
		// Если в ПечатьТорговыхДокументов.ПечатьСчетаНаОплату() мы добавили макеты новых документов, которых не было ОбъектыПечати - добавим их
		Для каждого ОбъектПечати Из ОбъектыПечатиВрем Цикл
			Если МассивСчетов.Найти(ОбъектПечати.Значение) = Неопределено 
				И ОбъектыПечати.НайтиПоЗначению(ОбъектПечати.Значение) = Неопределено Тогда
				
				ОбъектыПечати.Добавить(ОбъектПечати.Значение, ОбъектПечати.Представление);
			КонецЕсли; 
		КонецЦикла; 
		
		// Имя печатной формы заполним по счету
		ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов,
			КоллекцияПечатныхФорм,
			ОбъектыПечатиВрем,
			ПараметрыВывода);
			
		
		Если СоответствиеСчетовРеализациям <> Неопределено Тогда
			// Подменим счета на реализации в ключах имен файлов, так как по объектах при печати комплекта будет именно реализация
			Если КоллекцияПечатныхФорм.Количество() = 1 Тогда
				Для каждого СписокСчетовДляРеализации Из СоответствиеСчетовРеализациям Цикл
					// Каждой реализации могут соотвествовать несколько счетов, перечислим их имена через запятую
					МассивИмяФайлаПечатнойФормы = Новый Массив;
					Для каждого СчетДляРеализаиии Из СписокСчетовДляРеализации.Значение Цикл
						МассивИмяФайлаПечатнойФормы.Добавить(КоллекцияПечатныхФорм[0].ИмяФайлаПечатнойФормы[СчетДляРеализаиии]);
					КонецЦикла; 
					ИмяФайлаПечатнойФормы = СтрСоединить(МассивИмяФайлаПечатнойФормы, ", ");
					Если ИмяФайлаПечатнойФормы <> Неопределено Тогда
						КоллекцияПечатныхФорм[0].ИмяФайлаПечатнойФормы.Вставить(СписокСчетовДляРеализации.Ключ, ИмяФайлаПечатнойФормы);
					КонецЕсли; 
				КонецЦикла; 
			КонецЕсли;
				
			Если НЕ ПараметрыВывода.Свойство("ДокументыКомплекта") Тогда
				ПараметрыВывода.Вставить("ДокументыКомплекта", Новый Соответствие);
			КонецЕсли; 
			
			Для каждого СчетПоРеализации Из СоответствиеСчетовРеализациям Цикл
				Если ПараметрыВывода.ДокументыКомплекта[СчетПоРеализации.Ключ] = Неопределено Тогда
					ПараметрыВывода.ДокументыКомплекта.Вставить(СчетПоРеализации.Ключ, Новый Соответствие);
				КонецЕсли; 
				
				ПараметрыВывода.ДокументыКомплекта[СчетПоРеализации.Ключ].Вставить(СинонимМакета, СчетПоРеализации.Значение);
			КонецЦикла; 
		КонецЕсли;
		
	КонецЦикла;
	
	ПараметрыВывода.Вставить("ФормироватьЭД", Истина);
КонецПроцедуры


Процедура ВывестиСообщениеНеУказанСчетНаОплату(ДокументыБезСчетов, СокращенноеСообщениеОбОшибке = Ложь) Экспорт
	
	Если СокращенноеСообщениеОбОшибке Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "ЗАПОЛНЕНИЕ", НСтр("ru = 'Счет на оплату'"));
		Для каждого Реализация Из ДокументыБезСчетов Цикл 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, 
				Реализация,
				"СчетНаОплатуПокупателю",
				"Объект");
		КонецЦикла;
	Иначе
		Для каждого Реализация Из ДокументыБезСчетов Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В документе %1 не указан счет на оплату'"), Реализация); 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстСообщения, 
				Реализация);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
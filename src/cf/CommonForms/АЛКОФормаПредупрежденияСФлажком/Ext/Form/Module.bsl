﻿
////////////////////////////////////////////////////////////////////////////////
//
// Параметры формы:
//
//	 	Заголовок 				- Строка - Заголовок формы.
// 		ТекстЗаголовкаФлажка	- Строка - Заголовок для флажка формы. Если пуст - флажок не показывается.
// 		ТекстПредупреждения		- Строка - Текст выводимого сообщения.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заголовок = Параметры.Заголовок;
	
	Элементы.ДекорацияПредупреждение.Заголовок = Параметры.ТекстПредупреждения;
	
	СостояниеФлажка = Ложь;
	
	Если ЗначениеЗаполнено(Параметры.ТекстЗаголовкаФлажка) Тогда
	    Элементы.Флажок.Заголовок = Параметры.ТекстЗаголовкаФлажка;
	Иначе	
	    Элементы.Флажок.Видимость = Ложь;
	КонецЕсли;
	
	УникальностьФормы = Параметры.УникальностьФормы;
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ВладелецФормы = Неопределено Тогда
	    Отказ = Истина;
		ТекстПредупреждения = НСтр("ru='Данная форма вспомогательная, предназначена для 
										|показа предупреждения
										|из форм регламентированных отчетов!'");
		ПоказатьПредупреждение(, ТекстПредупреждения, НСтр("ru='Форма предупреждения с флажком.'"));
		Возврат;	
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = УникальностьФормы Тогда
		
		Если НРег(ИмяСобытия) = НРег("ЗакрытьОткрытыеФормы") Тогда			
		    Закрыть(СостояниеФлажка);			
		КонецЕсли;
					
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Закрыть(СостояниеФлажка);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#КонецОбласти



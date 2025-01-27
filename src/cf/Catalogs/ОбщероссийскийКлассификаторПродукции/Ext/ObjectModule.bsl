﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Ссылка")
		И ТипЗнч(ДанныеЗаполнения.Ссылка) = Тип("СправочникСсылка.ОбщероссийскийКлассификаторПродукции") Тогда
		
		РеквизитыОбъектаКопирования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения.Ссылка, "Код, Наименование, НаименованиеПолное");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыОбъектаКопирования);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
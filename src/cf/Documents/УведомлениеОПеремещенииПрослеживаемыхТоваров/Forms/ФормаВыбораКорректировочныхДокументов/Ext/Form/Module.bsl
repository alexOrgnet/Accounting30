﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТаблицаКорректировочныеДокументы = Параметры.КорректировочныеДокументы;
	КлючСтроки =                       Параметры.КлючСтроки;
	ПорядковыйНомер =                  Параметры.ПорядковыйНомер;
	Организация =           	       Параметры.Организация;
	Контрагент =             		   Параметры.Контрагент;
	
	КорректировочныеДокументы.Загрузить(
		ТаблицаКорректировочныеДокументы.Выгрузить(Новый Структура("КлючСтроки,ПорядковыйНомер", КлючСтроки, ПорядковыйНомер)));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если Модифицированность И ПроверитьЗаполнение()  Тогда
		
		ПараметрыПередачи = Новый Структура("КорректировочныеДокументы,КлючСтроки,ПорядковыйНомер", 
			КорректировочныеДокументы, КлючСтроки, ПорядковыйНомер);
		
		ОповеститьОВыборе(ПараметрыПередачи);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти


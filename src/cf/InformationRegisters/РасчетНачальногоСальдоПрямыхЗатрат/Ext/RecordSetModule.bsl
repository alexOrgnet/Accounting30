﻿// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		РегистрыСведений.РасчетКалькуляцииСебестоимости.ПривестиПериодРасчета(Запись.ПериодРасчета);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли

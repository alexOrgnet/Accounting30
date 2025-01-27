﻿// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПрограммныйИнтерфейс
Процедура ПривестиПериодРасчета(ПериодРасчета) Экспорт
	
	// Для регистра используется соглашение: 
	// ПериодРасчета - это всегда дата начала месяца, за который рассчитана себестоимость.
	// Это сделано из соображений производительности.
	// См. РасчетСебестоимости.СоздатьСтатьиКалькуляцииНачальноеСальдо()
	ПериодРасчета = НачалоМесяца(ПериодРасчета);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
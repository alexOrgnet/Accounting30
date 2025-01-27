﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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

Процедура ЗаменитьСчетПФР_ОПС_ИП() Экспорт
	
	СчетУчетаУдаленный = ПланыСчетов.Хозрасчетный.УдалитьПФР_ОПС_ИП;
	СчетУчетаНовый     = ПланыСчетов.Хозрасчетный.ПФР_ОПС_ИП;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СчетУчетаУдаленный", СчетУчетаУдаленный);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрочиеРасчеты.Регистратор
	|ИЗ
	|	РегистрНакопления.ПрочиеРасчеты КАК ПрочиеРасчеты
	|ГДЕ
	|	ПрочиеРасчеты.СчетУчета = &СчетУчетаУдаленный";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыНакопления.ПрочиеРасчеты.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Значение = Выборка.Регистратор;
		НаборЗаписей.Прочитать();
		
		Для Каждого Запись Из НаборЗаписей Цикл
			Если Запись.СчетУчета = СчетУчетаУдаленный Тогда
				Запись.СчетУчета = СчетУчетаНовый;
			КонецЕсли;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли
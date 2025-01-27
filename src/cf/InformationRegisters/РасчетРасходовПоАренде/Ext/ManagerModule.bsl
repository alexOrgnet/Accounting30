﻿
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

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиОбновления

Процедура ЗаполнитьПустойПериод(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
	|	РасчетРасходовПоАренде.Организация КАК Организация,
	|	РасчетРасходовПоАренде.Регистратор КАК Регистратор
	|ПОМЕСТИТЬ Регистраторы
	|ИЗ
	|	РегистрСведений.РасчетРасходовПоАренде КАК РасчетРасходовПоАренде
	|ГДЕ
	|	РасчетРасходовПоАренде.Период = ДАТАВРЕМЯ(1, 1, 1)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Регистраторы.Регистратор КАК Регистратор,
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.ДатаРегистратора, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаРегистратора
	|ИЗ
	|	Регистраторы КАК Регистраторы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|		ПО Регистраторы.Организация = ДанныеПервичныхДокументов.Организация
	|			И Регистраторы.Регистратор = ДанныеПервичныхДокументов.Документ
	|ГДЕ
	|	ЕСТЬNULL(ДанныеПервичныхДокументов.ДатаРегистратора, ДАТАВРЕМЯ(1, 1, 1)) <> ДАТАВРЕМЯ(1, 1, 1)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			Набор = РегистрыСведений.РасчетРасходовПоАренде.СоздатьНаборЗаписей();
			Набор.Отбор.Регистратор.Установить(Выборка.Регистратор);
			Набор.Прочитать();
			ТаблицаЗаписей = Набор.Выгрузить();
			ТаблицаЗаписей.ЗаполнитьЗначения(Выборка.ДатаРегистратора, "Период");
			Набор.Загрузить(ТаблицаЗаписей);
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Процедуре РегистрыСведений.РасчетРасходовПоАренде.ЗаполнитьПустойПериод
				|не удалось обработать записи по регистратору: %1 по причине:
				|%2'"),
				Выборка.Регистратор, 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
				УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.РегистрыСведений.РасчетРасходовПоАренде, 
				Выборка.Регистратор, 
				ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если ОбъектовОбработано = 0 Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Процедуре РегистрыСведений.РасчетРасходовПоАренде.ЗаполнитьПустойПериод
			|не удалось обработать записи по регистраторам (пропущены): %1'"),
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), 
			УровеньЖурналаРегистрации.Информация,
			Метаданные.РегистрыСведений.РасчетРасходовПоАренде,
			,
			СтрШаблон(
				НСтр("ru = 'Процедура РегистрыСведений.РасчетРасходовПоАренде.ЗаполнитьПустойПериод
				|обработала очередную порцию наборов записей: %1'"), 
				ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

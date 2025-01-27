﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		ДанныеЛицензий = Параметры.НачальноеЗначениеВыбора;
		Для НомСтр = 0 По ДанныеЛицензий.Количество() / 3 - 1 Цикл
			НоваяСтрока = ТаблицаЗначений.Добавить();
			НоваяСтрока.НомерЛицензии = ДанныеЛицензий["НомЛиц" + НомСтр];
			НоваяСтрока.ДатаВыдачиЛицензии = ДанныеЛицензий["ДатаЛиц" + НомСтр];
			НоваяСтрока.НаименованиеОрганизацииВыдавшейЛицензию = ДанныеЛицензий["ОргЛиц" + НомСтр];
		КонецЦикла;
	Исключение
	КонецПопытки;

КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаписатьЗавершение", ЭтотОбъект);
	
	Для НомСтр = 0 По ТаблицаЗначений.Количество() - 1 Цикл
		Если Не (ЗначениеЗаполнено(ТаблицаЗначений.Получить(НомСтр).НомерЛицензии)
			И ЗначениеЗаполнено(ТаблицаЗначений.Получить(НомСтр).ДатаВыдачиЛицензии)
			И ЗначениеЗаполнено(ТаблицаЗначений.Получить(НомСтр).НаименованиеОрганизацииВыдавшейЛицензию)) Тогда
			ПоказатьВопрос(ОписаниеОповещения,"Внимание! Не все данные табличной части заполнены." + Символы.ПС
			+ "Продолжить?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗавершение(Ответ, ДополнительныеПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Нет Тогда 
		Возврат;
	КонецЕсли;
			
	ДанныеЛицензий = Новый Структура;
	
	Для НомСтр = 0 По ТаблицаЗначений.Количество() - 1 Цикл
		ДанныеЛицензий.Вставить("НомЛиц"  + НомСтр, ТаблицаЗначений.Получить(НомСтр).НомерЛицензии);
		ДанныеЛицензий.Вставить("ДатаЛиц" + НомСтр, ТаблицаЗначений.Получить(НомСтр).ДатаВыдачиЛицензии);
		ДанныеЛицензий.Вставить("ОргЛиц"  + НомСтр, ТаблицаЗначений.Получить(НомСтр).НаименованиеОрганизацииВыдавшейЛицензию);
	КонецЦикла;
	
	Закрыть(ДанныеЛицензий);
	
КонецПроцедуры	
	
#КонецОбласти
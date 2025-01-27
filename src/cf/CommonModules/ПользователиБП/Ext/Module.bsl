﻿
#Область ПрограммныйИнтерфейс

// См. ЦентрМониторингаПереопределяемый.ПриСбореПоказателейСтатистикиКонфигурации.
Процедура ПриСбореПоказателейСтатистикиКонфигурации() Экспорт
	
	ПоказателиСтатистики = ПоказателиСтатистикиПоПользователям();
	
	ЦентрМониторинга.ЗаписатьОперациюБизнесСтатистики(
		"СтатистикаБП.Пользователи.РолиПользователей",
		1,
		ОбщегоНазначенияБП.ЗначениеВСтрокуJSON(ПоказателиСтатистики, Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет)));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПоказателиСтатистикиПоПользователям()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоОтбора", НачалоГода(ТекущаяДатаСеанса()));
	
	Запрос.Текст = "ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Пользователь,
	|	Пользователи.ИдентификаторПользователяИБ КАК ИдентификаторПользователяИБ
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.Служебный
	|	И НЕ Пользователи.Недействителен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЖурналОпераций.Ответственный КАК Пользователь,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЖурналОпераций.Ссылка) КАК Количество
	|ИЗ
	|	ЖурналДокументов.ЖурналОпераций КАК ЖурналОпераций
	|ГДЕ
	|	ЖурналОпераций.Дата >= &НачалоОтбора
	|
	|СГРУППИРОВАТЬ ПО
	|	ЖурналОпераций.Ответственный";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаПользователи = РезультатыЗапроса[0].Выбрать();
	ТаблицаДокументов = РезультатыЗапроса[1].Выгрузить();
	
	ПоказателиСтатистики = Новый Структура;
	ПоказателиСтатистики.Вставить("ДатаСобытия", НачалоЧаса(ТекущаяДатаСеанса()));
	ПоказателиСтатистики.Вставить("Пользователи", Новый Массив);
	
	Пока ВыборкаПользователи.Следующий() Цикл
		
		СтатистикаПользователя = Новый Структура;
		СтатистикаПользователя.Вставить("Пользователь", ВыборкаПользователи.ИдентификаторПользователяИБ);
		
		ДокументыПользователя = ТаблицаДокументов.Найти(ВыборкаПользователи.Пользователь, "Пользователь");
		Если ДокументыПользователя <> Неопределено Тогда
			КоличествоДокументов = ДокументыПользователя.Количество;
		Иначе
			КоличествоДокументов = 0;
		КонецЕсли;
		
		СтатистикаПользователя.Вставить("КоличествоДокументовСНачалаГода", КоличествоДокументов);
		
		ПоказателиСтатистики.Пользователи.Добавить(СтатистикаПользователя);
		
	КонецЦикла;
	
	Возврат ПоказателиСтатистики;
	
КонецФункции

#КонецОбласти

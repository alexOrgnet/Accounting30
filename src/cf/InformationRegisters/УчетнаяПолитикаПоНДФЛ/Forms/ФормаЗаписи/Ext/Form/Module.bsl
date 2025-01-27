﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ПрочитатьСтрокуУчетнойПолитикиИзИБ(ТекущийОбъект)
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УчестьИзмененияВДанныхУчета(ТекущийОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьСтрокуУчетнойПолитикиИзИБ(ТекущийОбъект)

	СтарыеДанные = Новый Структура("ИгнорироватьДниС30МартаПо3Апреля, ИгнорироватьДниС4По30Апреля, ИгнорироватьДниС6По8Мая", Ложь, Ложь, Ложь);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетнаяПолитикаПоНДФЛ.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	УчетнаяПолитикаПоНДФЛ.ОсобенностиИсчисленияНДФЛ КАК ОсобенностиИсчисленияНДФЛ,
	|	УчетнаяПолитикаПоНДФЛ.ИгнорироватьДниС30МартаПо3Апреля КАК ИгнорироватьДниС30МартаПо3Апреля,
	|	УчетнаяПолитикаПоНДФЛ.ИгнорироватьДниС4По30Апреля КАК ИгнорироватьДниС4По30Апреля,
	|	УчетнаяПолитикаПоНДФЛ.ИгнорироватьДниС6По8Мая КАК ИгнорироватьДниС6По8Мая
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаПоНДФЛ КАК УчетнаяПолитикаПоНДФЛ
	|ГДЕ
	|	УчетнаяПолитикаПоНДФЛ.ГоловнаяОрганизация = &ГоловнаяОрганизация";
	Запрос.УстановитьПараметр("ГоловнаяОрганизация", ТекущийОбъект.ГоловнаяОрганизация);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтарыеДанные, Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УчестьИзмененияВДанныхУчета(ТекущийОбъект)

	Если СтарыеДанные.ИгнорироватьДниС30МартаПо3Апреля <> ТекущийОбъект.ИгнорироватьДниС30МартаПо3Апреля
		Или СтарыеДанные.ИгнорироватьДниС4По30Апреля <> ТекущийОбъект.ИгнорироватьДниС4По30Апреля
		Или СтарыеДанные.ИгнорироватьДниС6По8Мая <> ТекущийОбъект.ИгнорироватьДниС6По8Мая Тогда
		УчетНДФЛ.ПересмотретьСрокиУплаты(ТекущийОбъект.ГоловнаяОрганизация, '20200325', '20200508')
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

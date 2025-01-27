﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяШаблона = Параметры.ИмяШаблона;
	Шаблон = Параметры.Шаблон;
	
	ПредставлениеПеременных = СтрСоединить(Параметры.ДоступныеПеременные.ВыгрузитьЗначения(), Символы.ПС);
	
	ДоступныеПеременные = СтрШаблон(НСтр("ru = 'Доступные переменные:
	|
	|%1'"), ПредставлениеПеременных);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
	ИначеЕсли Модифицированность И НЕ ПеренестиВНастройки Тогда
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ПеренестиВНастройки И Модифицированность Тогда
		Результат = Новый Структура;
		Результат.Вставить("ИмяШаблона", ИмяШаблона);
		Результат.Вставить("Шаблон", Шаблон);
		
		ОповеститьОВыборе(Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	ПеренестиВНастройки = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	
	ТекстВопроса = НСтр("ru = 'Восстановить шаблон по умолчанию?'");
	Оповещение = Новый ОписаниеОповещения("ВопросВосстановитьЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ШаблонПросмотрПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВНастройки = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВНастройки = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросВосстановитьЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.ОК Тогда
		ВосстановитьШаблонПоУмолчанию();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьШаблонПоУмолчанию()
	
	Шаблон = Обработки.НастройкиБиллинга.ПолучитьМакет(ИмяШаблона).ПолучитьТекст();
	
КонецПроцедуры

#КонецОбласти

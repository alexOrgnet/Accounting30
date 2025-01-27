﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресХранилищаСпецификации = "";
	Если Параметры.Свойство("АдресХранилищаСпецификации", АдресХранилищаСпецификации) Тогда
		ЗагрузитьТаблицуСпецификацииИзВременногоХранилища(АдресХранилищаСпецификации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		Отказ = Истина;
		
		Оповещение = Новый ОписаниеОповещения("ВопросСохраненияДанныхЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
	ИначеЕсли ПеренестиВДокумент Тогда
		
		ОбработкаПроверкиЗаполненияНаКлиенте(Отказ);
		
		Если Отказ Тогда
			Модифицированность = Истина;
			ПеренестиВДокумент = Ложь;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		АдресХранилищаСпецификации = ПоместитьТаблицуСпецификацииВоВременноеХранилище();
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("АдресХранилищаСпецификации", АдресХранилищаСпецификации);
		ОповеститьОВыборе(СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаПроверкиЗаполненияНаКлиенте(Отказ)
	
	Для Индекс = 0 По Спецификации.Количество() - 1 Цикл
		
		СтрокаСпецификации = Спецификации[Индекс];
		
		Префикс = "Спецификации[%1]";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Префикс, Формат(Индекс, "ЧН=0; ЧГ="));
				
		ИмяСписка = "Спецификации";
				
		Если НЕ ЗначениеЗаполнено(СтрокаСпецификации.ДатаСпецификации) Тогда
			Поле = Префикс + ".ДатаСпецификации";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Дата спецификации'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаСпецификации.НомерСпецификации) Тогда
			Поле = Префикс + ".НомерСпецификации";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Номер спецификации'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТаблицуСпецификацииИзВременногоХранилища(АдресХранилища)

	ТаблицаСпецификации = ПолучитьИзВременногоХранилища(АдресХранилища);
	Спецификации.Загрузить(ТаблицаСпецификации);

КонецПроцедуры

&НаСервере
Функция ПоместитьТаблицуСпецификацииВоВременноеХранилище()
	
	ТаблицаСпецификации = Спецификации.Выгрузить();
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаСпецификации, УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ВопросСохраненияДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

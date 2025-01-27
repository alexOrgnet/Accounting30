﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьТаблицуВыпискиБанкаИзВременногоХранилища(Параметры.АдресХранилищаВыпискиБанка);
	ЗагрузитьТаблицуСведенияОЗачетеИзВременногоХранилища(Параметры.АдресХранилищаСведенияОЗачете);
	ЗагрузитьТаблицуСведенияОДокументахИзВременногоХранилища(Параметры.АдресХранилищаСведенияОДокументах);
	
	Организация = Параметры.Организация;
	Период = Параметры.Период;
	
	Элементы.ГруппаСведенияОПлатежныхДокументах.Видимость = Период < '20150101';
	Элементы.ГруппаДокументы.Видимость = Период >= '20150101';
	
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
		
		СтруктураВозврата = Новый Структура;
		
		АдресХранилищаВыпискиБанка = ПоместитьТаблицуВыпискиБанкаВоВременноеХранилище();
		СтруктураВозврата.Вставить("АдресХранилищаВыпискиБанка", АдресХранилищаВыпискиБанка);
		
		АдресХранилищаСведенияОЗачете = ПоместитьТаблицуСведенияОЗачетеВоВременноеХранилище();
		СтруктураВозврата.Вставить("АдресХранилищаСведенияОЗачете", АдресХранилищаСведенияОЗачете);
		
		АдресХранилищаСведенияОДокументах = ПоместитьТаблицуСведенияОДокументахВоВременноеХранилище();
		СтруктураВозврата.Вставить("АдресХранилищаСведенияОДокументах", АдресХранилищаСведенияОДокументах);
			
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
	
	Для Индекс = 0 По ВыпискиБанка.Количество() - 1 Цикл
		
		СтрокаВыпискиБанка = ВыпискиБанка[Индекс];
		
		Префикс = "ВыпискиБанка[%1]";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Префикс, Формат(Индекс, "ЧН=0; ЧГ="));
				
		ИмяСписка = "Сведения о выписках банка";
				
		Если НЕ ЗначениеЗаполнено(СтрокаВыпискиБанка.ПлатежныйДокумент) Тогда
			Поле = Префикс + ".ПлатежныйДокумент";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Платежный документ'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаВыпискиБанка.СуммаОплаты) Тогда
			Поле = Префикс + ".СуммаОплаты";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Сумма оплаты'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Индекс = 0 По СведенияОЗачете.Количество() - 1 Цикл
		
		СтрокаСведенияОЗачете = СведенияОЗачете[Индекс];
		
		Префикс = "СведенияОЗачете[%1]";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Префикс, Формат(Индекс, "ЧН=0; ЧГ="));
				
		ИмяСписка = "Сведения о зачете";
				
		Если НЕ ЗначениеЗаполнено(СтрокаСведенияОЗачете.ПлатежныйДокумент) Тогда
			Поле = Префикс + ".ПлатежныйДокумент";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Платежный документ'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
			Если НЕ ЗначениеЗаполнено(СтрокаСведенияОЗачете.ДатаЗачета) Тогда
			Поле = Префикс + ".ДатаЗачета";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Дата зачета'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
	
		Если НЕ ЗначениеЗаполнено(СтрокаСведенияОЗачете.СуммаЗачета) Тогда
			Поле = Префикс + ".СуммаЗачета";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Сумма зачета'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТаблицуВыпискиБанкаВоВременноеХранилище()
	
	ТаблицаВыпискиБанка = ВыпискиБанка.Выгрузить();
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаВыпискиБанка, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция ПоместитьТаблицуСведенияОЗачетеВоВременноеХранилище()
	
	ТаблицаСведенияОЗачете = СведенияОЗачете.Выгрузить();
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаСведенияОЗачете, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция ПоместитьТаблицуСведенияОДокументахВоВременноеХранилище()
	
	ТаблицаСведенияОДокументах = СведенияОДокументах.Выгрузить();
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаСведенияОДокументах, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьТаблицуВыпискиБанкаИзВременногоХранилища(АдресХранилища)

	ТаблицаВыпискиБанка = ПолучитьИзВременногоХранилища(АдресХранилища);
	ВыпискиБанка.Загрузить(ТаблицаВыпискиБанка);

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТаблицуСведенияОЗачетеИзВременногоХранилища(АдресХранилища)

	ТаблицаСведенияОЗачете = ПолучитьИзВременногоХранилища(АдресХранилища);
	СведенияОЗачете.Загрузить(ТаблицаСведенияОЗачете);

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТаблицуСведенияОДокументахИзВременногоХранилища(АдресХранилища)
	
	ТаблицаСведенияОДокументах = ПолучитьИзВременногоХранилища(АдресХранилища);
	СведенияОДокументах.Загрузить(ТаблицаСведенияОДокументах);
	
КонецПроцедуры

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
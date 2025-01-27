﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,
		"Дата,СчетФактура,КодВидаОперации,НДСПредъявленКВычету,АдресХранилищаПродавцы,
		|ЭтоКомиссияНаЗакупку,ЭтоВыданныйДокумент,РаздельныйУчетНДС");

	ЗагрузитьТаблицуПродавцыИзВременногоХранилища(АдресХранилищаПродавцы);
	
	Если ЭтоВыданныйДокумент Тогда
		ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры;
	Иначе
		ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ПолученныеСчетаФактуры;
	КонецЕсли;
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		ЧастьЖурнала,
		Элементы.КодВидаОперации.СписокВыбора,
		Дата);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
	
	ИначеЕсли Модифицированность И НЕ ПеренестиВДокумент Тогда
		
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

	Если ПеренестиВДокумент Тогда
		СтруктураРезультат = Новый Структура("КодВидаОперации,НДСПредъявленКВычету,АдресХранилищаПродавцы");
		СтруктураРезультат.КодВидаОперации = КодВидаОперации;
		СтруктураРезультат.НДСПредъявленКВычету = НДСПредъявленКВычету;
		СтруктураРезультат.АдресХранилищаПродавцы = ПоместитьТаблицуПродавцыВоВременноеХранилище();
		ОповеститьОВыборе(СтруктураРезультат);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодВидаОперацииПриИзменении(Элемент)
	
	ТекущийКод = Элемент.СписокВыбора.НайтиПоЗначению(КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		НадписьВидОперации = Сред(ТекущийКод.Представление, 5);
	Иначе
		НадписьВидОперации = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущийКод = Элемент.СписокВыбора.НайтиПоЗначению(КодВидаОперации);
	ОповещениеВыбора = Новый ОписаниеОповещения("ВыборИзСпискаЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеВыбора, Элемент.СписокВыбора, Элемент, ТекущийКод);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВсеРеквизитыНажатие(Элемент)
	
	ПоказатьЗначение( , СчетФактура);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	ПеренестиВДокумент = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ГруппаПродавцы.Видимость = Форма.ЭтоКомиссияНаЗакупку;
	Элементы.ДекорацияВсеРеквизиты.Видимость = ЗначениеЗаполнено(Форма.СчетФактура);
	Элементы.НДСПредъявленКВычету.Видимость = Не Форма.ЭтоВыданныйДокумент И Не Форма.РаздельныйУчетНДС;
	
	ТекущийКод = Элементы.КодВидаОперации.СписокВыбора.НайтиПоЗначению(Форма.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		Форма.НадписьВидОперации = Сред(ТекущийКод.Представление, 5);
	Иначе
		Форма.НадписьВидОперации = "";
	КонецЕсли;
	
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

&НаКлиенте
Процедура ВыборИзСпискаЗавершение(ВыбранныйКод, ДополнительныеПараметры) Экспорт

	Если ВыбранныйКод <> Неопределено Тогда
		Модифицированность = Истина;
		КодВидаОперации = ВыбранныйКод.Значение;
		НадписьВидОперации = Сред(ВыбранныйКод.Представление, 5);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПроверкиЗаполненияНаКлиенте(Отказ)

	Если Не ЗначениеЗаполнено(КодВидаОперации) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Поле", "Заполнение", НСтр("ru = 'Код вида операции'"));
		Поле = "КодВидаОперации";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
	КонецЕсли;

	Если ЭтоКомиссияНаЗакупку И Продавцы.Количество() = 0 Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(
			"Список", "Заполнение", , , НСтр("ru = 'Продавцы'"));
		Поле = "Продавцы";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПоместитьТаблицуПродавцыВоВременноеХранилище()
	
	ТаблицаПродавцы = Продавцы.Выгрузить();
	Возврат ПоместитьВоВременноеХранилище(ТаблицаПродавцы, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьТаблицуПродавцыИзВременногоХранилища(АдресХранилища)

	Если Не ЗначениеЗаполнено(АдресХранилища) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаПродавцы = ПолучитьИзВременногоХранилища(АдресХранилища);
	Продавцы.Загрузить(ТаблицаПродавцы);

КонецПроцедуры


#КонецОбласти
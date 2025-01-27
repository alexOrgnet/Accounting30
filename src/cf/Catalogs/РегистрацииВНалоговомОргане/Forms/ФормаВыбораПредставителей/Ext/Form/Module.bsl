﻿
#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.АдресВременногоХранилищаПредставителей)
		Или Не ЭтоАдресВременногоХранилища(Параметры.АдресВременногоХранилищаПредставителей) Тогда
		// В форму не передан адрес временного хранилища с данными о подписантах.
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	СведенияОПодписантах = ПолучитьИзВременногоХранилища(Параметры.АдресВременногоХранилищаПредставителей);
	РегистрацияВНОСервер.ЗаполнитьСведенияОПодписантахВРегистрации(ЭтотОбъект, СведенияОПодписантах);
	
	РегистрацияВНОСервер.ИнициализацияПодписантовПриСозданииНаСервере(ЭтотОбъект, ЭтотОбъект);
	РегистрацияВНОСервер.ИзменитьПредставлениеПодписантаРуководителя(ЭтотОбъект, ЭтотОбъект);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	РегистрацияВНОКлиент.ОбработкаВыбораПодписантов(ЭтотОбъект, ЭтотОбъект, ВыбранноеЗначение);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтчетностьПодписываетПредставительПриИзменении(Элемент)
	
	РегистрацияВНОКлиент.ОтчетностьПодписываетПредставительПриИзменении(ЭтотОбъект, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПредставителяНажатие(Элемент, СтандартнаяОбработка)
	
	РегистрацияВНОКлиент.ПредставлениеПредставителяНажатие(ЭтотОбъект, ЭтотОбъект, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ПодписантыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РегистрацияВНОКлиент.ПодписантыВыбор(ЭтотОбъект, ЭтотОбъект, ВыбраннаяСтрока, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)

	Если НЕ ПодписантыУказаныКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	Адрес = ВладелецФормы.УникальныйИдентификатор;
	Закрыть(СведенияОПодписантахВоВременноеХранилище(Адрес));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПодписанта(Команда)
	
	РегистрацияВНОКлиент.ДобавитьПодписанта(ЭтотОбъект, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПодписанта(Команда)

	РегистрацияВНОКлиент.УдалитьПодписанта(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СведенияОПодписантахВоВременноеХранилище(Адрес)
	
	РегистрацияВНОСервер.ПередЗаписьюРегистрацииНаСервере(ЭтотОбъект, ЭтотОбъект);
	
	СведенияОПодписантах = РегистрацияВНОСервер.СведенияОПодписантахПоРегистрации(ЭтотОбъект);
	
	АдресВременногоХранилищаПредставителей = ПоместитьВоВременноеХранилище(СведенияОПодписантах, Адрес);
	Возврат АдресВременногоХранилищаПредставителей;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма) Экспорт

	РегистрацияВНОКлиентСервер.ИзменитьОформлениеПодписантов(Форма, Форма);
		
КонецПроцедуры

&НаСервере
Функция ПодписантыУказаныКорректно()
	
	Возврат РегистрацияВНОСервер.ПодписантыУказаныКорректно(ЭтотОбъект, ЭтотОбъект);
	
КонецФункции

&НаСервере
Процедура ПеренестиПодписантаИзШапкиВТаблицу() Экспорт
	
	РегистрацияВНОСервер.ПеренестиПодписантаИзШапкиВТаблицу(ЭтотОбъект, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Менеджер = Документы.ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов;
	ВидимостьПоляРебенок = СЭДОФСС.ВидимостьПоляРодственник();
	ВидимостьПоляДокументОснование = Менеджер.ВидимостьОснования();
	ДатаФорм2022 = Менеджер.ДатаФорм2022();
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", 
			"Объект.Организация",
			"Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере("Объект", "ПриСозданииНаСервере");
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	Элемент = Элементы.ОплатыСтатус;
	Для Каждого ЭлементСписка Из Элемент.СписокВыбора Цикл
		ЭлементУО = ОбщегоНазначенияБЗК.ДобавитьУсловноеОформление(ЭтотОбъект, Элемент.Имя);
		ОбщегоНазначенияБЗК.УстановитьПараметрУсловногоОформления(ЭлементУО, "Текст", ЭлементСписка.Представление);
		ОбщегоНазначенияБЗК.ДобавитьОтборУсловногоОформления(ЭлементУО, Элемент.ПутьКДанным, "=", ЭлементСписка.Значение);
	КонецЦикла;
	
	Элементы.ОплатыЗаполнить.Видимость         = ВидимостьПоляДокументОснование;
	Элементы.ОплатыДокументОснование.Видимость = ВидимостьПоляДокументОснование;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект, "ПриЧтенииНаСервере");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ПриПолученииДанныхНаСервере("Объект", "ПриЗагрузкеДанныхИзНастроекНаСервере");
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ФормаОткрыта = Не Отказ;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект, "ПослеЗаписиНаСервере");
	
	ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект);
	ФиксацияУстановитьОбъектЗафиксирован();
	ФиксацияОбновитьФиксациюВФорме();
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗакрытием(ЭтотОбъект, Объект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ОбновитьВторичныеДанныеИЭлементыФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ПредставлениеАдресаОрганизацииЗавершениеВыбора", ЭтотОбъект);
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ЮрАдресОрганизации"),
		Объект.АдресОрганизации);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, ЭтотОбъект, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОрганизацииЗавершениеВыбора(СтруктураАдреса, ПараметрыОповещения) Экспорт 
	Если ТипЗнч(СтруктураАдреса) = Тип("Структура")Тогда
		Объект.АдресОрганизации = СтруктураАдреса.Значение;
		ФиксацияЗафиксироватьИзменениеРеквизита("АдресОрганизации");
		ОбновитьПоляВводаКонтактнойИнформации();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТелефонСоставителяПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ТелефонСоставителяПредставлениеЗавершениеВыбора", ЭтотОбъект);
	ПараметрыОткрытия = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ТелефонОрганизации"),
		Объект.ТелефонСоставителя);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, ЭтотОбъект, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ТелефонСоставителяПредставлениеЗавершениеВыбора(СтруктураТелефона, ПараметрыОповещения) Экспорт 
	Если ТипЗнч(СтруктураТелефона) = Тип("Структура") Тогда
		Объект.ТелефонСоставителя = СтруктураТелефона.Значение;
		ФиксацияЗафиксироватьИзменениеРеквизита("ТелефонСоставителя");
		ОбновитьПоляВводаКонтактнойИнформации();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АдресЭлектроннойПочтыОрганизацииПриИзменении(Элемент)
	ФиксацияЗафиксироватьИзменениеРеквизита("АдресЭлектроннойПочтыОрганизации");
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыОплаты

&НаКлиенте
Процедура ОплатыПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("ОбновитьОтображениеПредупрежденийТЧ_Оплаты", 0.2, Истина);	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыСотрудникПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Оплаты.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Идентификатор = ТекущаяСтрока.ПолучитьИдентификатор();
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, "Сотрудник", Идентификатор);
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, "Ребенок", Идентификатор);
	ОбновитьВторичныеДанныеИЭлементыФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОплатыСреднедневнойЗаработокПриИзменении(Элемент)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "СреднедневнойЗаработок", ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыСуммаПособияПриИзменении(Элемент)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "СуммаПособия", ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыСуммаВзносовПриИзменении(Элемент)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "СуммаВзносов", ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыКоличествоСтраницПриИзменении(Элемент)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "КоличествоСтраниц", ЭтотОбъект.ТекущийЭлемент.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыДокументОснованиеПриИзменении(Элемент)
	ТекущаяСтрока = Элементы.Оплаты.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Или Не ЗначениеЗаполнено(ТекущаяСтрока.ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	Идентификатор = ТекущаяСтрока.ПолучитьИдентификатор();
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, "ДокументОснование", Идентификатор);
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, "Сотрудник", Идентификатор);
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтотОбъект, "Ребенок", Идентификатор);
	ОбновитьВторичныеДанныеИЭлементыФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОплатыРебенокПриИзменении(Элемент)
	ОбновитьВторичныеДанныеИЭлементыФормы();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ОбработчикиСобытийПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокумента(Команда)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Команда, Объект)
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокументаОповещение(Контекст, ДополнительныеПараметры) Экспорт
	ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Контекст);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Контекст, Объект);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийНаправившегоОткрытие(Элемент, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийНаправившегоОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийСледующемуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийСледующемуНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ЗаполнитьОплаты(Команда)
	ЗаполнитьДокумент();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВторичныеДанные(Команда)
	ОбновитьВторичныеДанныеИЭлементыФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВсеИсправления(Команда) 
	ОтменитьВсеИсправленияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПодробно(Команда)
	ОплатыПодробно = Не ОплатыПодробно;
	ОбновитьЭлементыФормы();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПояснениеНажатие(Элемент, СтандартнаяОбработка = Ложь)

	СотрудникиКлиент.ПояснениеНажатие(Элемент, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область Свойства

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ПодписиДокументов

// ЗарплатаКадрыПодсистемы.ПодписиДокументов
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент)
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
	Если Элемент.Имя = ПодписиДокументовКлиентСервер.ИмяЭлементаФормыПоРолиПодписанта("Руководитель") Тогда
		ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтотОбъект, "Руководитель");
		ОбновитьВторичныеДанныеИЭлементыФормы();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент)
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

&НаСервере
Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ИменаСлужебныхРеквизитов = ФиксацияВторичныхДанныхВДокументахКлиентСервер.ИменаСлужебныхРеквизитовИЭлементовМеханизмаФиксацииДанных();
	
	МассивИменРеквизитовФормы = Новый Массив;
	ЗарплатаКадры.ЗаполнитьМассивИменРеквизитовФормы(ЭтотОбъект, МассивИменРеквизитовФормы);
	
	Если МассивИменРеквизитовФормы.Найти(ИменаСлужебныхРеквизитов["ПараметрыФиксацииВторичныхДанных"]) = Неопределено Тогда
		ПараметрыФиксации = Документы.ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов.ПараметрыФиксацииВторичныхДанных();
		ПараметрыФиксации.Вставить("ОписаниеФормы", ФиксацияОписаниеФормы(ПараметрыФиксации));
	Иначе	
		ПараметрыФиксации = ЭтотОбъект[ИменаСлужебныхРеквизитов["ПараметрыФиксацииВторичныхДанных"]];
	КонецЕсли;
	
	Возврат ПараметрыФиксации;
	
КонецФункции

&НаСервере
Функция ФиксацияОписаниеФормы(ПараметрыФиксации) Экспорт
	
	ОписаниеФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеФормы();
	
	ОписаниеЭлементовФормы = Новый Соответствие();
	ОписаниеЭлементаФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	ОписаниеЭлементаФормы.ПрефиксПути = "Объект";
	ОписаниеЭлементаФормы.ПрефиксПутиТекущиеДанные = "Элементы.Оплаты.ТекущиеДанные";
	
	Для каждого ОписаниеФиксацииРеквизита Из ПараметрыФиксации.ОписаниеФиксацииРеквизитов Цикл
		ОписаниеЭлементовФормы.Вставить(ОписаниеФиксацииРеквизита.Ключ, ОписаниеЭлементаФормы);
	КонецЦикла;
	
	// Т.к. адреса редактируется через рек-т формы, укажем ему особые пути к данным.
	ПустоеОписаниеЭлементовФормы = ФиксацияВторичныхДанныхВДокументахФормы.ОписаниеЭлементаФормы();
	ОписаниеЭлементовФормы.Вставить("ПредставлениеАдресаОрганизации", ПустоеОписаниеЭлементовФормы);
	ОписаниеЭлементовФормы.Вставить("ТелефонСоставителяПредставление", ПустоеОписаниеЭлементовФормы);
	
	ОписаниеФормы.Вставить("ОписаниеЭлементовФормы", ОписаниеЭлементовФормы);
	ОписаниеФормы.Вставить("ФормаРедактируетсяПослеФиксации", Ложь);
	Возврат ОписаниеФормы;
КонецФункции

&НаСервере
Функция ФиксацияБыстрыйПоискРеквизитов()
	БыстрыйПоискРеквизитов = Новый Соответствие; // Ключ - имя элемента, значение - имя реквизита.
	ПараметрыФиксации = ЭтотОбъект["ПараметрыФиксацииВторичныхДанных"];
	Для Каждого КлючИЗначение Из ПараметрыФиксации.ОписаниеФиксацииРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Значение.ИмяРеквизита;
		// Поиск элементов по имени.
		Если Элементы.Найти(ИмяРеквизита) <> Неопределено Тогда
			БыстрыйПоискРеквизитов.Вставить(ИмяРеквизита, ИмяРеквизита);
		ИначеЕсли Элементы.Найти(ИмяРеквизита + "Представление") <> Неопределено Тогда
			БыстрыйПоискРеквизитов.Вставить(ИмяРеквизита + "Представление", ИмяРеквизита);
		ИначеЕсли Элементы.Найти("Оплаты" + ИмяРеквизита) <> Неопределено Тогда
			БыстрыйПоискРеквизитов.Вставить("Оплаты" + ИмяРеквизита, ИмяРеквизита);
		КонецЕсли;
	КонецЦикла;
	Возврат БыстрыйПоискРеквизитов;
КонецФункции

&НаСервере
Процедура ФиксацияОбновитьФиксациюВФорме()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьФорму(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ФиксацияЗаполнитьРеквизитыФормыФикс(ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахФормы.ЗаполнитьРеквизитыФормыФикс(ЭтаФорма, ТекущийОбъект);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ФиксацияЗаполнитьИдентификаторыФиксТЧ(Форма)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗаполнитьИдентификаторыСтрок(Форма);
КонецПроцедуры

&НаСервере
Процедура ФиксацияСохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СохранитьРеквизитыФормыФикс(Форма, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Функция ФиксацияПодготовленныйДокумент()
	
	ФиксацияЗаполнитьИдентификаторыФиксТЧ(ЭтаФорма);
	ПодготовленныйДокумент = РеквизитФормыВЗначение("Объект");
	ФиксацияСохранитьРеквизитыФормыФикс(ЭтаФорма, ПодготовленныйДокумент);
	
	Возврат ПодготовленныйДокумент;
	
КонецФункции

&НаСервере
Процедура ФиксацияУстановитьОбъектЗафиксирован();
	 ФиксацияВторичныхДанныхВДокументахФормы.УстановитьОбъектЗафиксирован(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеНаСервере()
	Если Не ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбъектФормыЗафиксирован(ЭтотОбъект) Тогда
		ДокументОбъект = ФиксацияПодготовленныйДокумент();
		Если ДокументОбъект.ОбновитьВторичныеДанные() Тогда
			Если Не ДокументОбъект.ЭтоНовый() Тогда
				ФиксацияВторичныхДанныхВДокументахФормы.УстановитьМодифицированность(ЭтотОбъект, Истина);
			КонецЕсли;
			ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
			ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтменитьВсеИсправленияНаСервере()
	
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОчиститьФиксациюИзменений(ЭтаФорма, Объект);
	ФиксацияЗаполнитьРеквизитыФормыФикс(Объект);
	ОбновитьВторичныеДанныеИЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(Элемент, СтандартнаяОбработка = Ложь) Экспорт
	ИдентификаторСтроки = Элементы.Оплаты.ТекущаяСтрока;
	ОписаниеЭлементов = ФиксацияБыстрыйПоискРеквизитов();
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.Подключаемый_ЗафиксироватьИзменениеРеквизитаВФорме(ЭтотОбъект, Элемент, ОписаниеЭлементов, ИдентификаторСтроки);
КонецПроцедуры

&НаСервере
Функция ОбъектЗафиксирован() Экспорт
	
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ОбъектЗафиксирован();
	
КонецФункции 

&НаКлиенте
Процедура ОбновитьОтображениеПредупрежденийТЧ_Оплаты()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ОбновитьОтображениеПредупрежденийТЧ(ЭтотОбъект, "Оплаты", Элементы.Оплаты.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ФиксацияЗафиксироватьИзменениеРеквизита(ИмяРеквизита, ТекущаяСтрока = 0)
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.ЗафиксироватьИзменениеРеквизита(ЭтаФорма, ИмяРеквизита, ТекущаяСтрока)
КонецПроцедуры

#КонецОбласти

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.Оплаты");
	Возврат Массив
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",	НСтр("ru = 'организации'")));
	Возврат Массив
КонецФункции

#КонецОбласти 

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ФиксацияВторичныхДанныхВДокументахКлиентСервер.СброситьФиксациюИзмененийРеквизитовПоОснованиюЗаполнения(ЭтаФорма, "Организация");
	ОбновитьВторичныеДанныеИЭлементыФормы();
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект, ИмяСобытия)
	
	// При открытии формы в целях оптимизации процедура вызывается только для последнего события.
	Если Не ФормаОткрыта
		И ИмяСобытия <> "ПриЗагрузкеДанныхИзНастроекНаСервере"
		И ОбщегоНазначенияБЗК.ЕстьСохраненныеНастройкиФормы(ЭтотОбъект) Тогда
		Возврат; // ПриПолученииДанныхНаСервере будет вызвана из ПриЗагрузкеДанныхИзНастроекНаСервере.
	КонецЕсли;
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ФиксацияВторичныхДанныхВДокументахФормы.ИнициализироватьМеханизмФиксацииРеквизитов(ЭтаФорма, ТекущийОбъект);
	ФиксацияВторичныхДанныхВДокументахФормы.ПодключитьОбработчикиФиксацииИзмененийРеквизитов(ЭтотОбъект, ФиксацияБыстрыйПоискРеквизитов());
	
	ОбновитьВторичныеДанныеИЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВторичныеДанныеИЭлементыФормы()
	ОбновитьВторичныеДанныеНаСервере();
	ОбновитьЭлементыФормы();
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыФормы()
	ОбновитьПоляВводаКонтактнойИнформации();
	ПодписиДокументовКлиентСервер.УстановитьПредставлениеПодписей(ЭтотОбъект);
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.Оплаты, "Месяц", "МесяцСтрокой");
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	ФиксацияОбновитьФиксациюВФорме();
	
	ДействуетФорма2022 = ДатаДокумента() >= ДатаФорм2022;
	
	Элементы.ОплатыРебенок.Видимость             = ДействуетФорма2022 И ВидимостьПоляРебенок;
	Элементы.ОплатыРебенокФИО.Видимость          = ДействуетФорма2022 И (Не ВидимостьПоляРебенок Или ОплатыПодробно);
	Элементы.ОплатыРебенокДатаРождения.Видимость = ДействуетФорма2022 И (Не ВидимостьПоляРебенок Или ОплатыПодробно);
	Элементы.ОплатыРебенокСНИЛС.Видимость        = ДействуетФорма2022 И (Не ВидимостьПоляРебенок Или ОплатыПодробно);
	Элементы.ОплатыСтатус.Видимость              = Не ДействуетФорма2022 Или Не ВидимостьПоляРебенок Или ОплатыПодробно;
	Элементы.ОплатыСотрудникФИО.Видимость        = ОплатыПодробно;
	Элементы.ОплатыСотрудникСНИЛС.Видимость      = ОплатыПодробно;
	Элементы.ОплатыПодробно.Пометка              = ОплатыПодробно;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокумент()
	Объект.Оплаты.Очистить();
	Запрос = ПрямыеВыплатыПособийСоциальногоСтрахования.ЗапросОплатДляВозмещенияВыплатРодителямДетейИнвалидов(Объект);
	Если Запрос <> Неопределено Тогда
		Объект.Оплаты.Загрузить(Запрос.Выполнить().Выгрузить());
	КонецЕсли;
	ПриПолученииДанныхНаСервере("Объект", "ПриЧтенииНаСервере");
КонецПроцедуры

&НаСервере
Функция ДатаДокумента()
	Если ЗначениеЗаполнено(Объект.Дата) Тогда
		Возврат Объект.Дата;
	Иначе
		Возврат ТекущаяДатаСеанса();
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ОбновитьПоляВводаКонтактнойИнформации()
	КонтактнаяИнформацияБЗК.ОбновитьПолеВводаАдреса(
		ЭтотОбъект,
		"ПредставлениеАдресаОрганизации",
		Объект.АдресОрганизации);
	
	КонтактнаяИнформацияБЗК.ОбновитьПолеВводаТелефона(
		ЭтотОбъект,
		"ТелефонСоставителяПредставление",
		Объект.ТелефонСоставителя);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыМесяцПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		Элементы.Оплаты.ТекущиеДанные, 
		"Месяц", 
		"МесяцСтрокой", 
		Модифицированность);
		
КонецПроцедуры

&НаКлиенте
Процедура ОплатыМесяцНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтотОбъект, 
		Элементы.Оплаты.ТекущиеДанные, 
		"Месяц", 
		"МесяцСтрокой");
		
КонецПроцедуры

&НаКлиенте
Процедура ОплатыМесяцРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		Элементы.Оплаты.ТекущиеДанные, 
		"Месяц", 
		"МесяцСтрокой", 
		Направление,
		Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыМесяцАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОплатыМесяцОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

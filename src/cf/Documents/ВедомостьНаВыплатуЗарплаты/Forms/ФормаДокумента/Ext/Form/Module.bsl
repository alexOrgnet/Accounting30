﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = 
			Новый Структура(
				"ПредыдущийМесяц, 
				|Ответственный", 
				"Объект.ПериодРегистрации",
				"Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
		
		УстановитьДоступностьЭлементов();
		
	КонецЕсли;
	
	Элементы.ЗарплатаКомпенсацияЗаЗадержкуЗарплаты.Видимость = Объект.Зарплата.Итог("КомпенсацияЗаЗадержкуЗарплаты") <> 0;
	Элементы.ЗарплатаВыплаченностьЗарплаты.Видимость =
		Объект.Зарплата.НайтиСтроки(Новый Структура("ВыплаченностьЗарплаты", Перечисления.ВыплаченностьЗарплаты.НеВыплачено)).Количество() > 0
		ИЛИ Объект.Зарплата.НайтиСтроки(Новый Структура("ВыплаченностьЗарплаты", Перечисления.ВыплаченностьЗарплаты.Задепонировано)).Количество() > 0;
	
	СвязьПараметровВыбораБанковскийСчет = Новый СвязьПараметраВыбора("Отбор.Владелец", "Элементы.Зарплата.ТекущиеДанные.ФизическоеЛицо", РежимИзмененияСвязанногоЗначения.Очищать);
	МассивСвязей = Новый Массив();
	МассивСвязей.Добавить(СвязьПараметровВыбораБанковскийСчет);
	ФиксированныйМассивСвязей = Новый ФиксированныйМассив(МассивСвязей);
	Элементы.ЗарплатаБанковскийСчет.СвязиПараметровВыбора = ФиксированныйМассивСвязей;
	
	ВидыДоходовИсполнительногоПроизводстваКлиентСервер.НастроитьПолеВидДоходаДляВыплатыЗарплаты(ЭтотОбъект,Объект.Дата,, Истина);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	НастроитьПоляИсполнительногоПроизводства();
	УстановитьПредставлениеОплаты();
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	
	УстановитьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ВзаиморасчетыССотрудникамиКлиент.ИмяСобытияИзмененияОплатыВедомости() Тогда
		УстановитьДоступностьЭлементов();
		УстановитьПредставлениеОплаты();
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Оповестить("Запись_ВедомостьНаВыплатуЗарплаты", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	НастроитьПоляИсполнительногоПроизводства();
	ВидыДоходовИсполнительногоПроизводстваКлиентСервер.НастроитьПолеВидДоходаДляВыплатыЗарплаты(ЭтотОбъект,Объект.Дата,, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		ЭтотОбъект, 
		"Объект.ПериодРегистрации", 
		"МесяцНачисленияСтрокой", 
		Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		ЭтотОбъект, 
		"Объект.ПериодРегистрации", 
		"МесяцНачисленияСтрокой", 
		Направление, 
		Модифицированность);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидМестаВыплатыПриИзменении(Элемент)
	НастроитьПоляИсполнительногоПроизводства();
КонецПроцедуры
	
&НаКлиенте
Процедура ОплатыПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыКлиент.ОплатаПоказать(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Оплатить(Команда)
	
	Если Объект.ПометкаУдаления Тогда
		ПоказатьПредупреждение( , НСтр("ru = 'Нельзя оформить выплату на основании документа, помеченного на удаление.'"));
		Возврат;
	Иначе
		Если Модифицированность Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Вставить(0, КодВозвратаДиалога.Да,     "Записать");
			Кнопки.Вставить(1, КодВозвратаДиалога.Отмена, "Отмена");
			
			Оповещение = Новый ОписаниеОповещения("ВопросПередВыплатойСледуетЗаписатьЗавершение", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, НСтр("ru = 'Перед выплатой документ следует записать'"), Кнопки,, КодВозвратаДиалога.Да);
		Иначе
			ОплатитьНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Колонка "Банковский счет" показывается только для перечисления на счет в банке

	ЭлементОформления = УсловноеОформление.Элементы.Добавить();

	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.ВидМестаВыплаты");
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	ЭлементОтбора.ПравоеЗначение = Перечисления.ВидыМестВыплатыЗарплаты.БанковскийСчет;

	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	ОформляемоеПоле = ЭлементОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ЗарплатаБанковскийСчет");

КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов() Экспорт
	
	ЕстьОплатаПоВедомости = ВзаиморасчетыССотрудниками.ЕстьОплатаПоВедомости(Объект.Ссылка);
	
	ТолькоПросмотр = 
		ДатыЗапретаИзменения.ИзменениеЗапрещено(Объект.Ссылка.Метаданные().ПолноеИмя(), Объект.Ссылка) 
		ИЛИ ВзаиморасчетыССотрудниками.ЕстьОплатаПоВедомости(Объект.Ссылка);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ГруппаОплатыКнопка",
		"Видимость",
		НЕ ЕстьОплатаПоВедомости);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"ГруппаОплатыСсылка",
		"Видимость",
		ЕстьОплатаПоВедомости);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"Оплатить",
		"Доступность",
		НЕ ТолькоПросмотр);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеОплаты() Экспорт
	
	ВедомостьНаВыплатуЗарплатыФормы.УстановитьПредставлениеОплаты(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПоляИсполнительногоПроизводства()
	
	Показывать = Перечисления.ВидыМестВыплатыЗарплаты.Безналичные().Найти(Объект.ВидМестаВыплаты) <> Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"ВидДоходаИсполнительногоПроизводства", 
		"Видимость", 
		Показывать);
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы(
		ЭтотОбъект, 
		"ВидДоходаИсполнительногоПроизводства", 
		Показывать И Документы.ВедомостьНаВыплатуЗарплаты.ВидДоходаИсполнительногоПроизводстваОбязателен(Объект));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, 
		"ЗарплатаВзысканнаяСумма", 
		"Видимость", 
		Показывать);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередВыплатойСледуетЗаписатьЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ДокументЗаписан = Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));
	Если НЕ ДокументЗаписан Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не удалось записать документ'"));
		Возврат;
	КонецЕсли;
	
	ОплатитьНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОплатитьНаСервере()
	
	ВедомостьНаВыплатуЗарплатыФормыПереопределяемый.СформироватьДокументыОплаты(ЭтотОбъект);
	УстановитьПредставлениеОплаты();
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

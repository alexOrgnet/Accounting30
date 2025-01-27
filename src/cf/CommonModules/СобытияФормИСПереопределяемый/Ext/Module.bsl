﻿#Область СлужебныйПрограммныйИнтерфейс

#Область Локализация

//Обработчик события вызывается на сервере при открытии формы конфигурации.
//   Выполняется определение необходимости встраивания подсистем (с учетом их наличия) в форму.
//
// Параметры:
//   Форма            - УправляемаяФорма - форма конфигурации
//   МодулиИнтеграции - Массив           - используемые модули интеграции
//
Процедура ПриОпределенииПараметровИнтеграцииФормыПрикладногоОбъекта(Форма, МодулиИнтеграции) Экспорт
	
	Модули = Новый Соответствие;
	
	ИмяФормы = Форма.ИмяФормы;
	Если ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокументаОбщая"
		Или ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокументаТовары"
		//Или ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокументаОбщая"
		//Или ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокументаОбщая"
		//Или ИмяФормы = "Документ.ОтчетОРозничныхПродажах.Форма.ФормаДокументаОбщая"
		Или ИмяФормы = "Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокументаОбщая"
		Или ИмяФормы = "Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокументаТовары"
		Тогда
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркировкиПродукцииВГИСМ") Тогда
			Модули.Вставить("СобытияФормГИСМ");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокументаОбщая"
		Или ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокументаТовары"
		Или ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокументаОбщая"
		Или ИмяФормы = "Документ.АктОРасхождениях.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.АктОРасхожденияхПолученный.Форма.ФормаДокумента"
		//Или ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокументаОбщая"
		Или ИмяФормы = "Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокументаОбщая"
		Или ИмяФормы = "Документ.ПоступлениеТоваровУслуг.Форма.ФормаДокументаТовары"
		Или ИмяФормы = "Документ.КорректировкаРеализации.Форма.ФормаДокумента"
		//Или ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		//Или ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК"
		Или ИмяФормы = "Документ.ПередачаТоваров.Форма.ФормаДокументаОбщая"
		Тогда
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетМаркируемойПродукцииИСМП") Тогда
			Модули.Вставить("СобытияФормИСМП");
		КонецЕсли;
		
	КонецЕсли;
	
	
	Если ИмяФормы = "Справочник.Номенклатура.Форма.ФормаВыбора" Тогда
		Если ПолучитьФункциональнуюОпцию("ВестиСведенияДляДекларацийПоАлкогольнойПродукции") Тогда
			Модули.Вставить("СобытияФормЕГАИС");
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект") 
		И ТипЗнч(Форма.Объект) = Тип("ДанныеФормыСтруктура") Тогда
		
		Если ИнтеграцияЕГАИС.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
			Модули.Вставить("СобытияФормЕГАИС");
		КонецЕсли;
		
		Если ИнтеграцияВЕТИС.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
			Модули.Вставить("СобытияФормВЕТИС");
		КонецЕсли;
		
		Если ИнтеграцияИСМП.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
			Модули.Вставить("СобытияФормИСМП");
		КонецЕсли;
		
		Если ИнтеграцияЗЕРНО.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
			Модули.Вставить("СобытияФормЗЕРНО");
		КонецЕсли;
		
		Если ИнтеграцияСАТУРН.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
			Модули.Вставить("СобытияФормСАТУРН");
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Модули Цикл
		МодулиИнтеграции.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

// Серверные обработчики БГосИС элементов прикладных форм
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный     - элемент-источник события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	
КонецПроцедуры

// Вызывается после записи объекта на сервере.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - источник вызова
Процедура ПослеЗаписиНаСервереФормыПрикладногоОбъекта(Форма) Экспорт
	
	Возврат;
	
КонецПроцедуры

Процедура ПриСозданииНаСервереВФормеПрикладногоОбъекта(Форма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийОбъектов

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяСправочника - Строка - имя справочника, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, ФормаКлиентскогоПриложения - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
Процедура ПриПолученииФормыСправочника(ИмяСправочника, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяДокумента - Строка - имя документа, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, УправляемаяФорма - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ПриПолученииФормыДокумента(ИмяДокумента, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ВидФормы = "ФормаСписка"
		И Параметры.Свойство("ТекущаяСтрока") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ФормаСпискаДокументов";
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяРегистра - Строка - имя регистра сведений, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, ФормаКлиентскогоПриложения - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
Процедура ПриПолученииФормыРегистраСведений(ИмяРегистра, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Возникает на сервере при создании формы.
//
// Параметры:
//  Форма - УправляемаяФорма - создаваемая форма,
//  Отказ - Булево - признак отказа от создания формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ИмяФормы = Форма.ИмяФормы;
	
	Если ИмяФормы = "Документ.ВозвратИзРегистра2ЕГАИС.Форма.ФормаСпискаДокументов" Тогда
		Форма.Элементы.СтраницаКОформлению.Видимость = Ложь;
		Форма.Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	Если ИмяФормы = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ИнформацияОНевозможностиДобавленияОтсканированного" Тогда
		МожноОткрытьФормуПроверкиПодбора = (Форма.Параметры.ИмяФормыИсточник = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокументаТовары");
		Для каждого ЭлементФормы Из Форма.Элементы Цикл
			Если СтрНачинаетсяС(ЭлементФормы.Имя, "ОткрытьФормуПроверкиИПодбора_") 
				И ЭлементФормы.Вид = ВидКнопкиФормы.КнопкаКоманднойПанели Тогда
				
				ЭлементФормы.Видимость = МожноОткрытьФормуПроверкиПодбора;
			КонецЕсли; 
		КонецЦикла; 
	ИначеЕсли ИмяФормы = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ПроверкаИПодбор" Тогда
		ИнтеграцияИСМПБП.ПодготовитьФормуПроверкаИПодбор(Форма);
	ИначеЕсли ИмяФормы = "Обработка.ПанельОбменЗЕРНО.Форма.Форма"
		Или ИмяФормы = "Справочник.НастройкиРегламентныхЗаданийЗЕРНО.Форма.ФормаНастроек" Тогда
		ИнтеграцияИСКлиентСервер.НастроитьОтборПоОрганизации(Форма, Форма.Организации, Неопределено, "Отбор");
	КонецЕсли; 
	
	ЭлементСерия = Форма.Элементы.Найти("Серия");
	Если ЭлементСерия <> Неопределено Тогда
		ЭлементСерия.Видимость = Ложь;
	КонецЕсли; 
	
	ЭлементХарактеристика = Форма.Элементы.Найти("Характеристика");
	Если ЭлементХарактеристика <> Неопределено Тогда
		ЭлементХарактеристика.Видимость = Ложь;
	КонецЕсли; 
	
	Если ИнтеграцияЕГАИСБП.СписокФормДляДобавленияБаннера().Найти(Форма.ИмяФормы) <> Неопределено Тогда
		ИнтеграцияЕГАИСБП.ДобавитьБаннерНаФорму(Форма);
	КонецЕсли;
	
	КнопкаПодбор = Форма.Элементы.Найти("ТоварыОткрытьПодбор");
	Если КнопкаПодбор = Неопределено Тогда
		КнопкаПодбор = Форма.Элементы.Найти("ТоварыОткрытьПодборНомеклатуры");
	КонецЕсли;
	
	Если КнопкаПодбор <> Неопределено Тогда
		КнопкаПодбор.Видимость = Ложь;
	КонецЕсли;
	
	Если ИмяФормы = "РегистрСведений.ПулКодовМаркировкиСУЗ.Форма.ФормаПечати" Тогда
		ИнтеграцияИСМПБП.ПодготовитьФормуПечатьЭтикетокИСМП(Форма);
	КонецЕсли;
	
	СобытияФормЗЕРНОБПВызовСервера.СкрытьХарактеристикуИСериюВДокументахЗЕРНО(Форма);
	
	Если Найти(ИмяФормы,"Классификатор")>0 И Найти(ИмяФормы,"ЗЕРНО")>0 Тогда
		КнопкаСкопировать = Форма.Элементы.Найти("ФормаСкопировать");
		Если КнопкаСкопировать <> Неопределено Тогда
			Форма.Элементы.ФормаСкопировать.Видимость = Ложь;	
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяФормы = "Документ.ОтчетОПроизводствеЕГАИС.Форма.ФормаДокумента" 
		ИЛИ ИмяФормы = "Документ.УведомлениеОПланируемомИмпортеЕГАИС" 
		ИЛИ ИмяФормы = "Документ.ОтчетОбИмпортеЕГАИС" Тогда
		ЭлементХарактеристика = Форма.Элементы.Найти("ТоварыХарактеристика");
		Если ЭлементХарактеристика <> Неопределено Тогда
			Форма.Элементы.ТоварыХарактеристика.Видимость = Ложь;	
		КонецЕсли;
		ЭлементХарактеристика = Форма.Элементы.Найти("СырьеХарактеристика");
		Если ЭлементХарактеристика <> Неопределено Тогда
			Форма.Элементы.СырьеХарактеристика.Видимость = Ложь;	
		КонецЕсли;
		ЭлементСерия = Форма.Элементы.Найти("ТоварыСерия");
		Если ЭлементСерия <> Неопределено Тогда
			Форма.Элементы.ТоварыСерия.Видимость = Ложь;
		КонецЕсли;
		ЭлементСерия = Форма.Элементы.Найти("СырьеСерия");
		Если ЭлементСерия <> Неопределено Тогда
			Форма.Элементы.СырьеСерия.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		
		Если ИмяФормы = "Документ.ВозвратВОборотИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.МаркировкаТоваровИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.ПеремаркировкаТоваровИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.ОтгрузкаТоваровИСМП.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.СписаниеКодовМаркировкиИСМП.Форма.ФормаСпискаДокументов" Тогда
			
			Форма.Элементы.СтраницыОформленоОтборОрганизация.Видимость = Ложь;
			Форма.Элементы.СтраницыКОформлениюОтборОрганизация.Видимость = Ложь;
			Форма.Элементы.СписокКОформлениюОрганизация.Видимость = Ложь;
			Форма.Элементы.Организация.Видимость = Ложь;
			Форма.Элементы.СписокКОформлениюОрганизация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ФормаСпискаДокументов" Тогда
			
			Форма.Элементы.СтраницыОформленоОтборОрганизация.Видимость = Ложь;
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Обработка.ПанельОбменИСМП.Форма.Форма" Тогда
			
			Форма.Элементы.СтраницыОтборОрганизация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Документ.ВозвратВОборотИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.МаркировкаТоваровИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ПеремаркировкаТоваровИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ОтгрузкаТоваровИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.СписаниеКодовМаркировкиИСМП.Форма.ФормаСписка" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Документ.ВозвратВОборотИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ЗаказНаЭмиссиюКодовМаркировкиСУЗ.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.МаркировкаТоваровИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ПеремаркировкаТоваровИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ОтгрузкаТоваровИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ФормаДокумента"
			ИЛИ ИмяФормы = "Документ.СписаниеКодовМаркировкиИСМП.Форма.ФормаДокумента" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
		ИначеЕсли ИмяФормы = "Документ.ПриемкаТоваровИСМП.Форма.ЗагрузкаВходящихДокументов" И Форма.Организации.Количество() Тогда
			Форма.Элементы.Организация.Видимость = Ложь;
		ИначеЕсли ИмяФормы = "Справочник.ШаблоныЭтикетокСУЗ.Форма.ФормаСписка" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Справочник.ШаблоныЭтикетокСУЗ.Форма.ФормаЭлемента" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "ОтчетИСМП.Форма.ФормаДокумента" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "ОтчетИСМП.Форма.ФормаСписка" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "ОтчетИСМП.Форма.ФормаСпискаДокументов" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		//ЗЕРНО
		ИначеЕсли ИмяФормы = "Документ.ФормированиеПартийЗЕРНО.Форма.ФормаСпискаДокументов"
			ИЛИ ИмяФормы = "Документ.ФормированиеПартийИзДругихПартийЗЕРНО.Форма.ФормаСпискаДокументов" Тогда
			
			Форма.Элементы.СтраницыОформленоОтборОрганизация.Видимость = Ложь;
			Форма.Элементы.СтраницыКОформлениюОтборОрганизация.Видимость = Ложь;
			Форма.Элементы.СписокКОформлениюОрганизация.Видимость = Ложь;
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Документ.ФормированиеПартийЗЕРНО.Форма.ФормаСписка"
			ИЛИ ИмяФормы = "Документ.ФормированиеПартийИзДругихПартийЗЕРНО.Форма.ФормаСписка" Тогда
			
			Форма.Элементы.Организация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Справочник.РеестрПартийЗЕРНО.Форма.ФормаСписка" Тогда
			
			Форма.Элементы.СтраницыОтборОрганизация.Видимость = Ложь;
			
		ИначеЕсли ИмяФормы = "Документ.ФормированиеПартийЗЕРНО.Форма.ФормаДокумента" Тогда
			
			Форма.Элементы.Организация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийБухгалтерскийУчет");
			
		ИначеЕсли ИмяФормы = "Обработка.ПанельОбменЗЕРНО.Форма.Форма" Тогда
			
			Форма.Элементы.СтраницыОтборОрганизация.Видимость = Ложь;
		
		КонецЕсли;	
	    //Конец ЗЕРНО
	КонецЕсли;
	
	Если ИмяФормы = "Документ.МаркировкаТоваровИСМП.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ОтгрузкаТоваровИСМП.Форма.ФормаДокумента"
		Или ИмяФормы = "Документ.ВыводИзОборотаИСМП.Форма.ФормаДокумента" Тогда
			Форма.Элементы.ТоварыСтавкаНДС.ОграничениеТипа = Новый ОписаниеТипов("ПеречислениеСсылка.СтавкиНДС");
	КонецЕсли;
	
	ДополнительныеПараметры = Неопределено;
	СобытияФормИС.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка, ДополнительныеПараметры);
	ШтрихкодированиеИС.ИнициализироватьКэшМаркируемойПродукции(Форма);
	
	Если ИмяФормы = "Обработка.ПанельАдминистрированияВЕТИС.Форма.НастройкиВЕТИС" Тогда
		ОписаниеРеквизита 						= Новый Структура("ИмяРеквизита,ЗаголовокРеквизита,ТипРеквизита");
		ОписаниеРеквизита.ИмяРеквизита 			= "ИспользоватьРаздельноеСписаниеМатериаловИВыпускПродукцииВЕТИС";
		ОписаниеРеквизита.ЗаголовокРеквизита 	= "Использовать производственные транзакции";
		ОписаниеРеквизита.ТипРеквизита 			= Новый ОписаниеТипов("Булево");
		СобытияФормВЕТИСБПВызовСервера.ДобавитьРеквизитФормы(Форма, ОписаниеРеквизита);
		
		СобытияФормВЕТИСБПВызовСервера.ОбновитьЗначениеРеквизитаФормы(Форма,"ИспользоватьРаздельноеСписаниеМатериаловИВыпускПродукцииВЕТИС");
		
		ОписаниеЭлемента 						= Новый Структура("ИмяЭлемента,ЗаголовокЭлемента,ПоложениеЗаголовка,ВидЭлемента,ПутьКДанным,РодительскаяГруппа,РасширеннаяПодсказка,ТекстПодсказки");
		ОписаниеЭлемента.ИмяЭлемента			= "ИспользоватьРаздельноеСписаниеМатериаловИВыпускПродукцииВЕТИС";
		ОписаниеЭлемента.ЗаголовокЭлемента		= "Использовать производственные транзакции";
		ОписаниеЭлемента.ПоложениеЗаголовка		= ПоложениеЗаголовкаЭлементаФормы.Право;
		ОписаниеЭлемента.ВидЭлемента			= ВидПоляФормы.ПолеФлажка;
		ОписаниеЭлемента.ПутьКДанным			= "ИспользоватьРаздельноеСписаниеМатериаловИВыпускПродукцииВЕТИС";
		ОписаниеЭлемента.РодительскаяГруппа 	= "ГруппаНастройкиПраваяПанель";
		ОписаниеЭлемента.РасширеннаяПодсказка 	= Истина;
		ОписаниеЭлемента.ТекстПодсказки        	= "Позволяет связать списание материалов в производство документом ""Расход материалов"" с выпуском продукции в ВЕТИС";
		Действие = Новый Структура("ИмяСобытия,ИмяОбработчика","ПриИзменении","Подключаемый_ПриИзмененииРеквизита");
		СобытияФормВЕТИСБПВызовСервера.ДобавитьЭлементУправления(Форма, ОписаниеЭлемента, Действие);
		
		СобытияФормВЕТИСБПВызовСервера.УстановитьВидимостьДополнительногоЭлемента(Форма,"ИспользоватьРаздельноеСписаниеМатериаловИВыпускПродукцииВЕТИС");
		
	КонецЕсли;
	
	Если ИмяФормы = "Документ.ПроизводственнаяОперацияВЕТИС.Форма.ФормаДокумента" Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьРаздельноеСписаниеМатериаловИВыпускПродукцииВЕТИС") Тогда
			СобытияФормВЕТИСБПВызовСервера.НастроитьЭлементыПроизводственнойТранзакцииНаФорме(Форма);
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяФормы = "Документ.ПроизводственнаяОперацияВЕТИС.Форма.ФормаСпискаДокументов" Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьРаздельноеСписаниеМатериаловИВыпускПродукцииВЕТИС") Тогда
			Форма["Список"].ТекстЗапроса = ИнтеграцияВЕТИСБПВызовСервера.ПолучитьТекстЗапросаСписка();
			
			ИнтеграцияВЕТИСБПВызовСервера.ДобавитьКолонкуВДинамическийСписокФормы(Форма,"Список","ПроизводственнаяТранзакция","Производственная транзакция");
			ИнтеграцияВЕТИСБПВызовСервера.ДобавитьКолонкуВДинамическийСписокФормы(Форма,"Список","СостояниеТранзакции","Состояние транзакции");
			
			ЭлементОтбора 					= Форма["Список"].Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("СтатусВЕТИС");
			ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.НеРавно;
			ЭлементОтбора.Использование 	= Истина;
			ЭлементОтбора.РежимОтображения 	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
			ЭлементОтбора.ПравоеЗначение 	= Перечисления.СтатусыОформленияДокументовГосИС.Оформлено;
		КонецЕсли;
	КонецЕсли;
    
КонецПроцедуры

// Вызывается при чтении объекта на сервере.
//
// Параметры:
//  Форма - УправляемаяФорма - форма читаемого объекта,
//  ТекущийОбъект - ДокументОбъект, СправочникОбъект - читаемый объект.
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	СобытияФормИС.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//          См. справочную информацию по событиям управляемой формы.
//  ТекущийОбъект - Произвольный - записанный объект.
//  ПараметрыЗаписи - Структура - использованные параметры записи объекта.
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	
	Возврат;
	
КонецПроцедуры

// Переопределяемая часть обработки проверки заполнения формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма.
//   Отказ - Булево - Истина если проверка заполнения не пройдена
//   ПроверяемыеРеквизиты - Массив Из Строка - реквизиты формы, отмеченные для проверки
Процедура ОбработкаПроверкиЗаполненияНаСервере(Форма, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	Если Форма.ИмяФормы = "ОбщаяФорма.ФормаУточненияДанныхИС" Тогда
		МассивНепроверяемыхРеквизитов = Новый Массив;
		МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
		МассивНепроверяемыхРеквизитов.Добавить("Серия");
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ИначеЕсли Форма.ИмяФормы = "ОбщаяФорма.ФормаУточненияПодобраннойПродукцииИСМП" Тогда
		МассивНепроверяемыхРеквизитов = Новый Массив;
		МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
		МассивНепроверяемыхРеквизитов.Добавить("Серия");
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
	КонецЕсли;
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиДействийФорм

// Возникает на сервере при записи константы в формах настроек
// если запись одной константы может повлечь изменение других отображаемых в этой же форме.
//
// Параметры:
//  Форма             - ФормаКлиентскогоПриложения - форма,
//  КонстантаИмя      - Строка           - записываемая константа,
//  КонстантаЗначение - Произвольный     - значение константы.
Процедура ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(Форма, КонстантаИмя, КонстантаЗначение) Экспорт
	
	Если КонстантаИмя = "ВестиУчетПодконтрольныхТоваровВЕТИС" Тогда
		ИмяПодчиненнойКонстанты = Метаданные.Константы.ИспользоватьРаздельноеСписаниеМатериаловИВыпускПродукцииВЕТИС.Имя;
		Если КонстантаЗначение = Ложь Тогда
			Константы.ИспользоватьРаздельноеСписаниеМатериаловИВыпускПродукцииВЕТИС.Установить(КонстантаЗначение);
		КонецЕсли;
		СобытияФормВЕТИСБПВызовСервера.ОбновитьЗначениеРеквизитаФормы(Форма, ИмяПодчиненнойКонстанты);
		СобытияФормВЕТИСБПВызовСервера.УстановитьВидимостьДополнительногоЭлемента(Форма,ИмяПодчиненнойКонстанты);
	КонецЕсли;

	
КонецПроцедуры

// Устанавливается свойство ОтображениеПредупрежденияПриРедактировании элемента формы.
//
Процедура ОтображениеПредупрежденияПриРедактировании(Элемент, Отображать) Экспорт

	Возврат
	
КонецПроцедуры

#КонецОбласти

#Область УсловноеОформление

// Устанавливает условное оформление для поля "Характеристика".
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой нужно установить условное оформление,
//  ИмяПоляВводаХарактеристики - Строка - имя элемента формы "Характеристика",
//  ПутьКПолюОтбора - Строка - полный путь к реквизиту "Характеристики используются".
//
Процедура УстановитьУсловноеОформлениеХарактеристикНоменклатуры(Форма, ИмяПоляВводаХарактеристики = "ТоварыХарактеристика", ПутьКПолюОтбора = "Объект.Товары.ХарактеристикиИспользуются") Экспорт
	
	Если Форма.ИмяФормы = "Документ.ФормированиеПартийЗЕРНО.Форма.ФормаДокумента" Тогда
		Возврат;
	КонецЕсли;
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляВводаХарактеристики].Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляВводаХарактеристики].Имя);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

// Устанавливает условное оформление для поля "Единица измерения".
//
// Параметры:
//  Форма - УправляемаяФорма - форма, в которой нужно установить условное оформление,
//  ИмяПоляВводаЕдиницИзмерения - Строка - имя элемента формы "Единица измерения",
//  ПутьКПолюОтбора - Строка - полный путь к реквизиту "Упаковка".
//
Процедура УстановитьУсловноеОформлениеЕдиницИзмерения(Форма,
	                                                  ИмяПоляВводаЕдиницИзмерения = "ТоварыНоменклатураЕдиницаИзмерения",
	                                                  ПутьКПолюОтбора = "Объект.Товары.Упаковка") Экспорт
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяПоляВводаЕдиницИзмерения);//ЭлементыФормы[ИмяПоляВводаЕдиницИзмерения].Имя);

	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКПолюОтбора);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

// Устанавливает условное оформление для поля "Серия".
//
// Параметры:
//	Форма - УправляемаяФорма - Форма, в которой нужно установить условное оформление,
//
Процедура УстановитьУсловноеОформлениеСерийНоменклатуры(Форма, ИмяПоляВводаСерии = "ТоварыСерия", ПутьКПолюОтбораСтатусУказанияСерий = "Объект.Товары.СтатусУказанияСерий", ПутьКПолюОтбораТипНоменклатуры = "Объект.Товары.ТипНоменклатуры") Экспорт
	
	Если Форма.ИмяФормы = "Документ.ФормированиеПартийЗЕРНО.Форма.ФормаДокумента" Тогда
		Возврат;
	КонецЕсли;

	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляВводаСерии].Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ЭлементыФормы[ИмяПоляВводаСерии].Имя);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

#КонецОбласти

#Область СвязиПараметровВыбора

// Устанавливает связь элемента формы с полем ввода номенклатуры.
//
// Параметры:
//	Форма					- ФормаКлиентскогоПриложения	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода			- Строка			- Имя поля, связываемого с номенклатурой.
//	ПутьКДаннымНоменклатуры	- Строка			- Путь к данным текущей номенклатуры в форме.
//
Процедура УстановитьСвязиПараметровВыбораСНоменклатурой(Форма, ИмяПоляВвода,
	ПутьКДаннымНоменклатуры = "Элементы.Товары.ТекущиеДанные.Номенклатура") Экспорт
	
	Возврат;
	
КонецПроцедуры

// Устанавливает связь элемента формы с полем ввода характеристики номенклатуры.
//
// Параметры:
//	Форма						- ФормаКлиентскогоПриложения	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода				- Строка			- Имя поля, связываемого с номенклатурой.
//	ПутьКДаннымХарактеристики	- Строка			- Путь к данным текущей характеристики номенклатуры в форме.
//
Процедура УстановитьСвязиПараметровВыбораСХарактеристикой(Форма, ИмяПоляВвода,
	ПутьКДаннымХарактеристики = "Элементы.Товары.ТекущиеДанные.Характеристика") Экспорт
	
	Возврат;
	
КонецПроцедуры

// Устанавливает связь элемента формы с полем договоры хранения. 
//
// Параметры:
//	Форма					- ФормаКлиентскогоПриложения	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода			- Строка			- Имя поля, связываемого с договором.
//
Процедура УстановитьСвязиПараметровВыбораДоговора(Форма, ИмяПоляВвода) Экспорт
	
	Возврат;
	
КонецПроцедуры


// Устанавливает параметры выбора договоры хранения.
//
//Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, в которой нужно установить параметры выбора.
//   ИмяПоляВвода            - Строка               - имя поля ввода договоры.
//
Процедура УстановитьПараметрыВыбораСвязиПараметровВыбораДоговора(Форма, ИмяПоляВвода = "Контрагент") Экспорт
	
	
	Возврат;
	
КонецПроцедуры

// Устанавливает связь элемента формы с полем ввода по владельцу
//
// Параметры:
//	Форма						- УправляемаяФорма	- Форма, в которой нужно установить связь.
//	ИмяПоляВвода				- Строка			- Имя поля, связываемого с номенклатурой.
//	ПутьКДаннымХарактеристики	- Строка			- Путь к данным текущего значения в форме.
//
Процедура УстановитьСвязиПараметровВыбораПоВладельцу(Форма, ИмяПоляВвода,
	ПутьКДаннымХарактеристики = "Элементы.Товары.ТекущиеДанные.Номенклатура") Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Устанавливает у элемента формы Упаковка подсказку ввода для соответствующей номенклатуры
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Форма объекта.
//
Процедура УстановитьИнформациюОЕдиницеХранения(Форма) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиИзмененияОпределяемыхТипов

#КонецОбласти

// Выполняет действия при изменении номенклатуры в объекте (форме, строке табличной части итп).
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - Произвольный - контекст редактирования (текущая строка таблицы, шапка объекта, форма)
//  КэшированныеЗначения   - Неопределено, Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - Произвольный - параметры указания серий формы
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения = Неопределено, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Номенклатура")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "КодТНВЭД") Тогда

		Если ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
			ТекущаяСтрока.КодТНВЭД = ИнтеграцияИСМПБПВызовСервера.КодТНВЭД(ТекущаяСтрока.Номенклатура);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Номенклатура")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "МаркируемаяПродукция") Тогда
		
		ТекущаяСтрока.МаркируемаяПродукция = ИнтеграцияИСМПБП.МаркируемаяПродукция(ТекущаяСтрока.Номенклатура);
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Номенклатура")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ТребуетВзвешивания") Тогда

		Если ЗначениеЗаполнено(ТекущаяСтрока.Номенклатура) Тогда
			ОписаниеНоменклатуры = РегистрыСведений.ОписаниеНоменклатурыИС.ПолучитьОписание(ТекущаяСтрока.Номенклатура)[ТекущаяСтрока.Номенклатура];
			
			ТекущаяСтрока.ТребуетВзвешивания = 
				ОписаниеНоменклатуры.ВариантИспользованияЕдиницыХранения = Перечисления.ВариантыИспользованияЕдиницыХраненияИС.МернаяПродукцияТребуетУказанияЗначения;
				
			ТекущаяСтрока.ПроизвольнаяЕдиницаУчета = 
				ОписаниеНоменклатуры.ВариантИспользованияЕдиницыХранения <> Перечисления.ВариантыИспользованияЕдиницыХраненияИС.ПотребительскаяУпаковка;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

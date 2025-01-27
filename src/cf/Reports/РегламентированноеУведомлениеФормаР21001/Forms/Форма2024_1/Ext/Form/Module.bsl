﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Данные = Неопределено;
	ПараметрыЗаполнения = Неопределено;
	Параметры.Свойство("Данные", Данные);
	Параметры.Свойство("ПараметрыЗаполнения", ПараметрыЗаполнения);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР21001;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2024_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления)
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		СформироватьДеревоСтраниц();
		
		ВходящийКонтейнер = Новый Структура("ИмяФормы, ДеревоСтраниц", ИмяФормы, РеквизитФормыВЗначение("ДеревоСтраниц"));
		РезультатКонтейнер = Новый Структура;
		УведомлениеОСпецрежимахНалогообложения.СформироватьКонтейнерДанныхУведомления(ВходящийКонтейнер, РезультатКонтейнер);
		Для Каждого КЗ Из РезультатКонтейнер Цикл
			ЭтотОбъект[КЗ.Ключ] = КЗ.Значение;
		КонецЦикла;
		
		РезультатКонтейнер.Очистить();
		
		ИнициализироватьМногострочныеЧасти(ВходящийКонтейнер, РезультатКонтейнер);
		
		Для Каждого КЗ Из РезультатКонтейнер Цикл
			ЗначениеВРеквизитФормы(КЗ.Значение, КЗ.Ключ);
		КонецЦикла;
		
		УведомлениеОСпецрежимахНалогообложения.ДополнитьСлужебнымиСтруктурамиАдреса(ДанныеУведомления, ДанныеМногостраничныхРазделов);
		
	КонецЕсли;
	
	Если Параметры.СформироватьФормуОтчетаАвтоматически Тогда
		ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения);
	КонецЕсли;
	
	Если Параметры.СформироватьПечатнуюФорму Тогда
		Модифицированность = Истина;
		СохранитьДанные();
		Отказ = Истина;
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СохраненныеДанныеУведомления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ДанныеУведомления").Получить();
		ДанныеПомощникаЗаполнения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(СохраненныеДанныеУведомления,
			"ДанныеПомощникаЗаполнения",
			Неопределено);
		УведомлениеЗаполненоВПомощнике = ЗначениеЗаполнено(ДанныеПомощникаЗаполнения);
	Иначе
		УведомлениеЗаполненоВПомощнике = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаУведомлениеИзПомощника.Видимость = УведомлениеЗаполненоВПомощнике;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(
		ЭтотОбъект, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	ПараметрыОповещения = Новый Структура("Организация, ВидУведомления", Объект.Организация, Объект.ВидУведомления);
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещения, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(
			ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтотОбъект);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент,
	НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УведомлениеОСпецрежимахНалогообложенияКлиент.НеобходимоФормированиеТабличногоДокумента(ЭтотОбъект, Элемент, ЭтотОбъект["УИДПереключение"]) Тогда
		ОтключитьОбработчикОжидания("ДеревоСтраницПриАктивизацииСтрокиЗавершение");
		ПодключитьОбработчикОжидания("ДеревоСтраницПриАктивизацииСтрокиЗавершение", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтрокиЗавершение() Экспорт 
	ПредУИД = ЭтотОбъект["УИДПереключение"];
	Элемент = Элементы.ДеревоСтраниц;
	
	ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета);
	Если Элемент.ТекущиеДанные.Многострочность Тогда
		Для Каждого СтрокаМСЧ Из Элемент.ТекущиеДанные.МногострочныеЧасти Цикл
			ИмяМСЧ = СтрокаМСЧ.Значение;
			ВывестиМногострочнуюЧасть(ИмяМСЧ);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	
	ИмяОбласти = Область.Имя;
	
	Если СтрЧислоВхождений(ИмяОбласти, "ДобавитьСтроку") > 0 Тогда
		ДобавитьСтроку(Неопределено);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(ИмяОбласти, "УдалитьСтроку") > 0 Тогда
		УдалитьСтроку(Неопределено);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	КонецЕсли;
	
	Если РучнойВвод Тогда
		Возврат;
	КонецЕсли;
	
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка);
	
	Если НЕ СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрНайти(ИмяОбласти, "П0107") = 1 Тогда
		ОбработкаАдреса(Область, СтандартнаяОбработка);
		Возврат;
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда
		Если ЭтоОбластьОКСМ(Область) Тогда
			СтандартнаяОбработка = Ложь;
			ДополнительныеПараметры = Новый Структура("Область, СтандартнаяОбработка, Элемент",
				Область, СтандартнаяОбработка, Элемент);
			ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораСтраныЗавершение",
				ЭтотОбъект, ДополнительныеПараметры);
			ОткрытьФорму("Справочник.СтраныМира.ФормаВыбора",
				Новый Структура("РежимВыбора", Истина), ЭтотОбъект, , , ,
				ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область);
	Если СтрНачинаетсяС(Область.Имя, "А01020000_") Тогда 
		Постфикс = Число(СтрЗаменить(Область.Имя, "А01020000_", ""));
		МногострочнаяЧастьА010200[Постфикс-1].А01020000 = Область.Значение;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриАктивизации(Элемент)
	
	Область = Элемент.ТекущаяОбласть;
	ИмяОбласти = Область.Имя;
	
	Элементы.ПредставлениеУведомленияКонтекстноеМенюОчиститьКодОКСМ.Доступность = ЭтоОбластьОКСМ(Область);
	НастроитьКонтекстноеМенюПредставленияУведомления(ИмяОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УведомлениеЗаполненоВПомощникеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ПомощникРегистрацииВЕГР" Тогда
		СтандартнаяОбработка = Ложь;
		
		МодульРегистрацияОрганизацииКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("РегистрацияОрганизацииКлиентСервер");
		ПараметрыПомощника = МодульРегистрацияОрганизацииКлиентСервер.НовыеПараметрыПомощникаВнесенияИзменений();
		ПараметрыПомощника.Организация = Объект.Организация;
		ПараметрыПомощника.КонтекстныйВызов = Истина;
		ПараметрыПомощника.Заявление = Объект.Ссылка;
		
		МодульРегистрацияОрганизацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РегистрацияОрганизацииКлиент");
		МодульРегистрацияОрганизацииКлиент.ОткрытьПомощникРегистрации(ПараметрыПомощника);
		
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьУведомлениеЗаполненоВПомощникеНажатие(Элемент)
	
	Элементы.ГруппаУведомлениеИзПомощника.Видимость = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьДанные();
	ПараметрыОповещения = Новый Структура("Организация, ВидУведомления", Объект.Организация, Объект.ВидУведомления);
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещения, Объект.Ссылка);
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКодОКСМ(Команда)
	
	ПредставлениеУведомления.ТекущаяОбласть.Значение = "";
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(
		ЭтотОбъект, ПредставлениеУведомления.ТекущаяОбласть);
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	
	Если ДоступнаПечатьPDF417(ИмяФормы) Тогда
		РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
	Иначе
		ТекстПредупреждения = НСтр("ru = 'Печать формы со штрихкодом PDF417 будет реализована в будущих версиях программы.'");
		ПоказатьПредупреждение( , ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура ПредварительныйПросмотр(Команда)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Ждать ВопросАсинх("Перед печатью необходимо сохранить изменения. Сохранить изменения?", РежимДиалогаВопрос.ДаНет) 
			<> КодВозвратаДиалога.Да Тогда 
			Возврат;
		КонецЕсли;
	ИначеЕсли Модифицированность Тогда
		СохранитьДанные();
	КонецЕсли;
	
	МассивПечати = Новый Массив;
	МассивПечати.Добавить(Объект.Ссылка);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОСпецрежимахНалогообложения",
		"Уведомление", МассивПечати, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПроверитьВыгрузку(ЭтотОбъект, ПроверитьВыгрузкуНаСервере());
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьДанные();
	ПараметрыОповещения = Новый Структура("Организация, ВидУведомления", Объект.Организация, Объект.ВидУведомления);
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещения, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	
	ЕстьВыходЗаГраницы = Ложь;
	ПечатьБРОНаСервере(ЕстьВыходЗаГраницы);
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(
		ЭтотОбъект, "Открыть", Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов,
		Новый Структура("ЕстьВыходЗаГраницы", ЕстьВыходЗаГраницы));
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтроку(Команда)
	
	Область = Элементы.ПредставлениеУведомления.ТекущаяОбласть;
	ИмяОбласти = Область.Имя;
	
	Если СтрНайти(ИмяОбласти, "ДобавитьСтроку") = 1 Тогда
		ИмяОбластиДобавленияСтроки = ИмяОбласти;
		ИдМСЧ = СтрЗаменить(ИмяОбласти, "ДобавитьСтроку", "");
		ИдМСЧ = СтрЗаменить(ИдМСЧ, "Значок", "");
	Иначе
		ПолноеИмяМСЧ = ОпределитьПринадлежностьОбластиКМногострочномуРазделу(ИмяОбласти);
		ИдМСЧ = ИдМСЧ(ПолноеИмяМСЧ);
		ИмяОбластиДобавленияСтроки = "ДобавитьСтроку" + ИдМСЧ;
	КонецЕсли;
	
	ПроверкаМаксимумаСтрок = ПроверитьДостижениеМаксимальногоКоличестваСтрок(ИдМСЧ);
	
	Если ПроверкаМаксимумаСтрок.ДостигнутМаксимум Тогда
		ПоказатьПредупреждение( , ПроверкаМаксимумаСтрок.ТекстПредупреждения);
	Иначе
		ДобавитьСтрокуНаСервере(ИмяОбластиДобавленияСтроки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Асинх Процедура УдалитьСтроку(Команда)
	Область = Элементы.ПредставлениеУведомления.ТекущаяОбласть;
	ИмяОбласти = Область.Имя;
	
	Если СтрНайти(ИмяОбласти, "УдалитьСтроку") = 1 Тогда
		ИмяОбластиУдаленияСтроки = ИмяОбласти;
	Иначе
		ПолноеИмяМСЧ = ОпределитьПринадлежностьОбластиКМногострочномуРазделу(ИмяОбласти);
		ИдМСЧ = ИдМСЧ(ПолноеИмяМСЧ);
		Постфикс = Сред(ИмяОбласти, СтрНайти(ИмяОбласти, "_"));
		ИмяОбластиУдаленияСтроки = "УдалитьСтроку" + ИдМСЧ + Постфикс;
	КонецЕсли;
	
	Если НЕ ПредставлениеУведомления.Области[ИмяОбластиУдаленияСтроки].Гиперссылка Тогда
		Возврат;
	КонецЕсли;
	
	Если Ждать ВопросАсинх("Удалить выбранную строку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		УдалитьСтрокуНаСервере(ИмяОбластиУдаленияСтроки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаКлиенте
Процедура НастроитьКонтекстноеМенюПредставленияУведомления(ИмяОбласти)
	
	ЭтоПоказательМСЧ = СтрНайти(ИмяОбласти, "П010707") = 1
	               ИЛИ СтрНайти(ИмяОбласти, "А010200") = 1;
	
	ЭтоЕдинственнаяСтрока = Истина;
	Если ЭтоПоказательМСЧ Тогда
		ИмяБезПостфикса = Лев(ИмяОбласти, СтрНайти(ИмяОбласти, "_") - 1);
		ИмяПоказателяВторойСтроки = ИмяБезПостфикса + "_2";
		ЭтоЕдинственнаяСтрока = (ПредставлениеУведомления.Области.Найти(ИмяПоказателяВторойСтроки) = Неопределено);
	КонецЕсли;
	
	Элементы.ПредставлениеУведомленияКонтекстноеМенюДобавитьСтроку.Доступность = ЭтоПоказательМСЧ;
	Элементы.ПредставлениеУведомленияКонтекстноеМенюУдалитьСтроку.Доступность =
		ЭтоПоказательМСЧ И НЕ ЭтоЕдинственнаяСтрока;
	
КонецПроцедуры

#КонецОбласти

#Область МногострочныеЧасти

&НаСервере
Процедура ДобавитьСтрокуНаСервере(ИмяОбласти)
	
	ИдМСЧ = СтрЗаменить(ИмяОбласти, "ДобавитьСтроку", "");
	ИдМСЧ = СтрЗаменить(ИдМСЧ, "Значок", "");
	ПолноеИмяМСЧ = "МногострочнаяЧасть" + ИдМСЧ;
	
	ЭтотОбъект[ПолноеИмяМСЧ].Добавить();
	ТаблицаМСЧ = РеквизитФормыВЗначение(ПолноеИмяМСЧ);
	НомерНовойСтроки = ТаблицаМСЧ.Количество();
	
	ИсходныйМакетРаздела = МакетОтчетаСодержащийМСЧ(ПолноеИмяМСЧ);
	ОбластьМСЧ = ИсходныйМакетРаздела.ПолучитьОбласть(ПолноеИмяМСЧ);
	Для Каждого КолонкаМСЧ Из ТаблицаМСЧ.Колонки Цикл
		ИмяПоказателя = КолонкаМСЧ.Имя;
		ОбластьПоказателя = ОбластьМСЧ.Область(ИмяПоказателя + "_1");
		ОбластьПоказателя.Имя = ИмяПоказателя + "_" + РегламентированнаяОтчетностьКлиентСервер.СтрЧГ0(НомерНовойСтроки);
	КонецЦикла;
	ОбластьУдаленияСтроки = ОбластьМСЧ.Область("УдалитьСтроку" + ИдМСЧ + "_1");
	ОбластьУдаленияСтроки.Имя = "УдалитьСтроку" + ИдМСЧ + "_" + РегламентированнаяОтчетностьКлиентСервер.СтрЧГ0(НомерНовойСтроки);
	
	ПозицияВставки = ПредставлениеУведомления.Область(ИмяОбласти).Верх;
	
	ПредставлениеУведомления.ВставитьОбласть(
		ОбластьМСЧ.Область(1, , ОбластьМСЧ.ВысотаТаблицы),
		ПредставлениеУведомления.Область(ПозицияВставки, , ПозицияВставки, ),
		ТипСмещенияТабличногоДокумента.ПоВертикали);
	
	УстановитьВидимостьУдаленияПервойСтроки(ИдМСЧ);
	
	ИмяОбластиДляАктивации = ТаблицаМСЧ.Колонки[0].Имя + "_" + РегламентированнаяОтчетностьКлиентСервер.СтрЧГ0(НомерНовойСтроки);
	Элементы.ПредставлениеУведомления.ТекущаяОбласть = ПредставлениеУведомления.Область(ИмяОбластиДляАктивации);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокуНаСервере(ИмяОбласти)
	
	ИмяБезПостфикса = Лев(ИмяОбласти, СтрНайти(ИмяОбласти, "_") - 1);
	ИдМСЧ = СтрЗаменить(ИмяБезПостфикса, "УдалитьСтроку", "");
	ПолноеИмяМСЧ = "МногострочнаяЧасть" + ИдМСЧ;
	НомерСтроки = Число(Сред(ИмяОбласти, СтрНайти(ИмяОбласти, "_") + 1));
	
	МногострочнаяЧасть = ЭтотОбъект[ПолноеИмяМСЧ];
	
	Если МногострочнаяЧасть.Количество() <= 1 Тогда
		Возврат;
	КонецЕсли;
	
	МногострочнаяЧасть.Удалить(НомерСтроки - 1);
	
	// Обрабатываются только многострочные части с высотой 2 строки
	// и показателями, расположенными в одной строке.
	ВысотаБлокаМСЧ = 2;
	НомерСтрокиМакета = ПредставлениеУведомления.Область(ИмяОбласти).Верх;
	УдаляемаяОбласть = ПредставлениеУведомления.Область(НомерСтрокиМакета, , НомерСтрокиМакета + ВысотаБлокаМСЧ - 1, );
	ПредставлениеУведомления.УдалитьОбласть(УдаляемаяОбласть, ТипСмещенияТабличногоДокумента.ПоВертикали);
	
	ТаблицаМСЧ = РеквизитФормыВЗначение(ПолноеИмяМСЧ);
	
	Пока Истина Цикл
		ОбластьУдаленияСтроки = ПредставлениеУведомления.Области.Найти(
			"УдалитьСтроку" + ИдМСЧ + "_" + РегламентированнаяОтчетностьКлиентСервер.СтрЧГ0(НомерСтроки + 1));
		Если ОбластьУдаленияСтроки = Неопределено Тогда
			Прервать;
		КонецЕсли;
		
		Для Каждого КолонкаМСЧ Из ТаблицаМСЧ.Колонки Цикл
			ИмяПоказателя = КолонкаМСЧ.Имя;
			ОбластьПоказателя = ПредставлениеУведомления.Область(ИмяПоказателя + "_" + РегламентированнаяОтчетностьКлиентСервер.СтрЧГ0(НомерСтроки + 1));
			ОбластьПоказателя.Имя = ИмяПоказателя + "_" + РегламентированнаяОтчетностьКлиентСервер.СтрЧГ0(НомерСтроки);
		КонецЦикла;
		ОбластьУдаленияСтроки.Имя = "УдалитьСтроку" + ИдМСЧ + "_" + РегламентированнаяОтчетностьКлиентСервер.СтрЧГ0(НомерСтроки);
		
		НомерСтроки = НомерСтроки + 1;
		
	КонецЦикла;
	
	УстановитьВидимостьУдаленияПервойСтроки(ИдМСЧ);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиМногострочнуюЧасть(ПолноеИмяМСЧ)
	
	ИдМСЧ = ИдМСЧ(ПолноеИмяМСЧ);
	ТаблицаМСЧ = РеквизитФормыВЗначение(ПолноеИмяМСЧ);
	ИсходныйМакетРаздела = МакетОтчетаСодержащийМСЧ(ПолноеИмяМСЧ);
	ПромежуточныйМакет = Новый ТабличныйДокумент;
	
	Инд = 1;
	Для Каждого Стр Из ЭтотОбъект[ПолноеИмяМСЧ] Цикл
		ОбластьМСЧ = ИсходныйМакетРаздела.ПолучитьОбласть(ПолноеИмяМСЧ);
		Для Каждого КолонкаМСЧ Из ТаблицаМСЧ.Колонки Цикл
			ИмяПоказателя = КолонкаМСЧ.Имя;
			ОбластьПоказателя = ОбластьМСЧ.Область(ИмяПоказателя + "_1");
			ОбластьПоказателя.Имя = ИмяПоказателя + "_" + РегламентированнаяОтчетностьКлиентСервер.СтрЧГ0(Инд);
			ОбластьПоказателя.Значение = Стр[ИмяПоказателя];
		КонецЦикла;
		
		ОбластьУдаленияСтроки = ОбластьМСЧ.Область("УдалитьСтроку" + ИдМСЧ + "_1");
		ОбластьУдаленияСтроки.Имя = "УдалитьСтроку" + ИдМСЧ + "_" + РегламентированнаяОтчетностьКлиентСервер.СтрЧГ0(Инд);
		
		ПромежуточныйМакет.Вывести(ОбластьМСЧ);
		Инд = Инд + 1;
		
	КонецЦикла;
	
	ИсходнаяОбластьМСЧ = ПредставлениеУведомления.Область(ПолноеИмяМСЧ);
	ПозицияВставки = ИсходнаяОбластьМСЧ.Верх;
	
	ПредставлениеУведомления.УдалитьОбласть(ИсходнаяОбластьМСЧ, ТипСмещенияТабличногоДокумента.ПоВертикали);
	
	ПредставлениеУведомления.ВставитьОбласть(
		ПромежуточныйМакет.Область(1, , ПромежуточныйМакет.ВысотаТаблицы),
		ПредставлениеУведомления.Область(ПозицияВставки, , ПозицияВставки, ),
		ТипСмещенияТабличногоДокумента.ПоВертикали);
	
	УстановитьВидимостьУдаленияПервойСтроки(ИдМСЧ);
	УведомлениеОСпецрежимахНалогообложения.ПозиционироватьсяНаЯчейке(ЭтотОбъект);
	Возврат;
	
КонецПроцедуры

&НаСервере
Функция МакетОтчетаСодержащийМСЧ(ПолноеИмяМСЧ)
	
	Если ПолноеИмяМСЧ = "МногострочнаяЧастьА010200" Тогда
		Возврат УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетТабличногоДокумента(ЭтотОбъект, "Форма2024_1_Страница4");
	ИначеЕсли ПолноеИмяМСЧ = "МногострочнаяЧастьП010707" Тогда
		Возврат УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетТабличногоДокумента(ЭтотОбъект, "Форма2024_1_Страница2");
	Иначе
		ВызватьИсключение НСтр("ru = 'Функция МакетОтчетаСодержащийМСЧ():
			|вызов функции с непредусмотренным значением параметра'");
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ИдМСЧ(ПолноеИмяМСЧ)
	
	Если ПолноеИмяМСЧ = "МногострочнаяЧастьА010200" Тогда
		Возврат "А010200";
	ИначеЕсли ПолноеИмяМСЧ = "МногострочнаяЧастьП010707" Тогда
		Возврат "П010707";
	Иначе
		ВызватьИсключение НСтр("ru = 'Функция ИдМСЧ():
			|вызов функции с непредусмотренным значением параметра'");
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ОпределитьПринадлежностьОбластиКМногострочномуРазделу(ИмяОбласти) Экспорт
	
	ИмяБезПостфикса = Лев(ИмяОбласти, СтрНайти(ИмяОбласти, "_") - 1);
	
	Если ИмяБезПостфикса = "А01020000" Тогда
		Возврат "МногострочнаяЧастьА010200";
	ИначеЕсли ИмяБезПостфикса = "П01070701" ИЛИ ИмяБезПостфикса = "П01070702" Тогда
		Возврат "МногострочнаяЧастьП010707";
	Иначе
		ВызватьИсключение НСтр("ru = 'Функция ОпределитьПринадлежностьОбластиКМногострочномуРазделу():
			|вызов функции с непредусмотренным значением параметра'");
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьУдаленияПервойСтроки(ИдМСЧ)
	
	ТаблицаМСЧ = ЭтотОбъект["МногострочнаяЧасть" + ИдМСЧ];
	УдалениеВозможно = (ТаблицаМСЧ.Количество() >= 2);
	
	ОбластьУдаленияСтроки = ПредставлениеУведомления.Область("УдалитьСтроку" + ИдМСЧ + "_1");
	ОбластьУдаленияСтроки.Гиперссылка = УдалениеВозможно;
	ОбластьУдаленияСтроки.Текст = ?(УдалениеВозможно, "х", "");
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьДостижениеМаксимальногоКоличестваСтрок(ИдМСЧ)
	
	Результат = Новый Структура("ДостигнутМаксимум, ТекстПредупреждения", Ложь, "");
	
	Если ИдМСЧ = "П010707" Тогда
		ИмяПредельногоПоказателя = "П01070701_3";
		Если ПредставлениеУведомления.Области.Найти(ИмяПредельногоПоказателя) <> Неопределено Тогда
			Результат.ДостигнутМаксимум = Истина;
			Результат.ТекстПредупреждения = НСтр("ru = 'Допускается не более 3 строк с указанием здания/сооружения'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ВводАдресаФИАС

&НаКлиенте
Процедура ОбработкаАдреса(Область, СтандартнаяОбработка) Экспорт
	
	// Эмуляция механизма многострочных частей из налоговой отчетности.
	СтруктураРеквизитовФормы_СтруктураМногострочныхЧастей = Новый Структура;
	ИменаГраф = Новый Массив;
	ИменаГраф.Добавить("П01070701");
	ИменаГраф.Добавить("П01070702");
	ИменаПодчиненныхГрупп = Новый Массив;
	СтруктураРеквизитовФормы_СтруктураМногострочныхЧастей.Вставить("П010707",
		Новый Структура("ИменаГраф, ИсхКолСтрок, УровеньПодчинения, ИменаПодчиненныхГрупп",
			ИменаГраф, 1, 0, ИменаПодчиненныхГрупп));
	
	СтандартнаяОбработка = Ложь;
	
	СоответствиеПоказателейСтраницыРеквизитамАдреса = СоответствиеПоказателейСтраницыРеквизитамАдреса(ИмяФормы);
	
	ПараметрыОпределенияАдреса = Новый Структура;
	ПараметрыОпределенияАдреса.Вставить("СтруктураМногострочныхЧастей",
		СтруктураРеквизитовФормы_СтруктураМногострочныхЧастей);
	ПараметрыОпределенияАдреса.Вставить("СоответствиеПоказателейСтраницыРеквизитамАдреса",
		СоответствиеПоказателейСтраницыРеквизитамАдреса);
	
	ПоляАдресаВJSON = "";
	Для Каждого Элем Из СоответствиеПоказателейСтраницыРеквизитамАдреса Цикл
		Если Элем.Значение = "СтрокаАдресногоОбъекта" Тогда
			ПоляАдресаВJSON = ПредставлениеУведомления.Области[Элем.Ключ].Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Ввод адреса");
	ПараметрыФормы.Вставить("ЗначенияПолей", ПоляАдресаВJSON);
	ПараметрыФормы.Вставить("ВидКонтактнойИнформации", УведомлениеОСпецрежимахНалогообложенияКлиент.ВидКонтактнойИнформацииАдресСПроверкой());
	
	ДополнительныеПараметры = Новый Структура;
	Оповещение = Новый ОписаниеОповещения("ОткрытьФормуКонтактнойИнформацииЗавершение",
		ЭтотОбъект, ДополнительныеПараметры);
	
	ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(
		ПараметрыФормы, , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьАдресВМестеХранения(Результат);
	
	Элемент= Элементы.ДеревоСтраниц;
	
	ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета);
	Если Элемент.ТекущиеДанные.Многострочность Тогда
		Для Каждого СтрокаМСЧ Из Элемент.ТекущиеДанные.МногострочныеЧасти Цикл
			ИмяМСЧ = СтрокаМСЧ.Значение;
			ВывестиМногострочнуюЧасть(ИмяМСЧ);
		КонецЦикла;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьАдресВМестеХранения(Результат)
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Адрес", Результат.Значение);
	ПараметрыЗаполнения.Вставить("СоответствиеПоказателейСтраницыРеквизитамАдреса",
		СоответствиеПоказателейСтраницыРеквизитамАдреса(ИмяФормы));
	ПараметрыЗаполнения.Вставить("ВерсияАдреса", 2);
	
	ВиртуальноеДеревоРазделов = Новый ДеревоЗначений;
	ВиртуальноеДеревоРазделов.Колонки.Добавить("Данные");
	ВиртуальноеДеревоРазделов.Колонки.Добавить("ДанныеМногострочныхЧастей");
	
	ВиртуальнаяВеткаРаздела = ВиртуальноеДеревоРазделов.Строки.Добавить();
	ВиртуальнаяВеткаРаздела.Данные = ДанныеУведомления.Лист002;
	ВиртуальнаяВеткаРаздела.ДанныеМногострочныхЧастей = Новый Структура("П010707", МногострочнаяЧастьП010707);
	
	ЗаполнитьАдресВФорматеФИАСНаСтраницеРеглОтчета(ВиртуальнаяВеткаРаздела, ПараметрыЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдресВФорматеФИАСНаСтраницеРеглОтчета(СтраницаРаздела, ПараметрыЗаполнения)
	
	СоответствиеПоказателейСтраницыРеквизитамАдреса = ПараметрыЗаполнения.СоответствиеПоказателейСтраницыРеквизитамАдреса;
	
	ДополнительныеПараметры = Неопределено;
	Если ПараметрыЗаполнения.Свойство("ВерсияАдреса") Тогда
		ДополнительныеПараметры = Новый Структура("ВерсияАдреса", ПараметрыЗаполнения.ВерсияАдреса);
	КонецЕсли;
	
	СтруктураАдреса = УведомлениеОСпецрежимахНалогообложения.АдресВФорматеФИАС(
		ПараметрыЗаполнения.Адрес, ДополнительныеПараметры);
	
	ДанныеСтраницы = СтраницаРаздела.Данные;
	
	Для Каждого Элем Из СоответствиеПоказателейСтраницыРеквизитамАдреса Цикл
		
		Если ДанныеСтраницы.Свойство(Элем.Ключ) Тогда
			// Немногострочные данные.
			ДанныеСтраницы.Вставить(Элем.Ключ, СтруктураАдреса[Элем.Значение]);
			
		ИначеЕсли СтраницаРаздела.ДанныеМногострочныхЧастей.Свойство(Элем.Ключ)
			И ТипЗнч(Элем.Значение) = Тип("Массив") И Элем.Значение.Количество() >= 2
			И ТипЗнч(Элем.Значение[0]) = Тип("Строка") И ЗначениеЗаполнено(Элем.Значение[0])
			И СтруктураАдреса.Свойство(Элем.Значение[0]) И ТипЗнч(СтруктураАдреса[Элем.Значение[0]]) = Тип("Массив")
			И ТипЗнч(Элем.Значение[1]) = Тип("Структура") Тогда
			
			ДанныеМСЧ = СтраницаРаздела.ДанныеМногострочныхЧастей[Элем.Ключ];
			ДанныеМСЧ.Очистить();
			
			СоответствиеМногострочнойЧастиМножественномуРеквизитуАдреса = Элем.Значение[1];
			
			МножественныйРеквизитАдреса = СтруктураАдреса[Элем.Значение[0]];
			
			Для Каждого РеквизитАдреса Из МножественныйРеквизитАдреса Цикл
				СтрокаМногострочнойЧасти = ДанныеМСЧ.Добавить();
				Для Каждого ЭлемСоответствия Из СоответствиеМногострочнойЧастиМножественномуРеквизитуАдреса Цикл
					СтрокаМногострочнойЧасти[ЭлемСоответствия.Ключ] = РеквизитАдреса[ЭлемСоответствия.Значение];
				КонецЦикла;
			КонецЦикла;
			
			Если ДанныеМСЧ.Количество() = 0 Тогда
				СтрокаМногострочнойЧасти = ДанныеМСЧ.Добавить();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

&НаСервере
Процедура ПечатьБРОНаСервере(ЕстьВыходЗаГраницы)
	
	ЕстьВыходЗаГраницы = Ложь;
	СохранитьДанные();
	СтруктураРеквизитовУведомления = Новый Структура("СписокПечатаемыхЛистов",
		Отчеты[ИДОтчета(ИмяФормы)].СформироватьСписокЛистов(Объект.Ссылка, ЕстьВыходЗаГраницы));
	
КонецПроцедуры

#КонецОбласти

#Область ИнтерфейсОбращенияКМодулюМенеджераИОбъекта

&НаСервере
Процедура ИнициализироватьМногострочныеЧасти(КонтейнерВходящий, КонтейнерРезультат) Экспорт
	
	Отчеты[ИДОтчета(ИмяФормы)].ИнициализироватьМногострочныеЧасти(
		ИДФормыОтчета(ИмяФормы), КонтейнерВходящий, КонтейнерРезультат);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоответствиеПоказателейСтраницыРеквизитамАдреса(ПолноеИмяФормы)
	
	Возврат Отчеты[ИДОтчета(ПолноеИмяФормы)].СоответствиеПоказателейСтраницыРеквизитамАдреса(
		ИДФормыОтчета(ПолноеИмяФормы));
	
КонецФункции

&НаСервереБезКонтекста
Функция ДоступнаПечатьPDF417(ПолноеИмяФормы)
	
	Возврат Отчеты[ИДОтчета(ПолноеИмяФормы)].ДоступнаПечатьPDF417(
		ИДФормыОтчета(ПолноеИмяФормы));
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИДОтчета(Знач ПолноеИмяФормы)
	
	ПолноеИмяФормы = СтрЗаменить(ПолноеИмяФормы, "Отчет.", "");
	ПолноеИмяФормы = Лев(ПолноеИмяФормы, СтрНайти(ПолноеИмяФормы, ".Форма.") - 1);
	
	Возврат ПолноеИмяФормы;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИДФормыОтчета(ПолноеИмяФормы)
	
	ИДФормыОтчета = Сред(ПолноеИмяФормы, СтрНайти(ПолноеИмяФормы, ".Форма.") + 7);
	
	Возврат ИДФормыОтчета;
	
КонецФункции

#КонецОбласти

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	
	СформироватьДеревоСтраниц();
	
	ВходящийКонтейнер = Новый Структура("ИмяФормы, ДеревоСтраниц", ИмяФормы, РеквизитФормыВЗначение("ДеревоСтраниц"));
	РезультатКонтейнер = Новый Структура;
	УведомлениеОСпецрежимахНалогообложения.СформироватьКонтейнерДанныхУведомления(ВходящийКонтейнер, РезультатКонтейнер);
	Для Каждого КЗ Из РезультатКонтейнер Цикл
		ЭтотОбъект[КЗ.Ключ] = КЗ.Значение;
	КонецЦикла;
	
	РезультатКонтейнер.Очистить();
	ИнициализироватьМногострочныеЧасти(ВходящийКонтейнер, РезультатКонтейнер);
	Для Каждого КЗ Из РезультатКонтейнер Цикл
		ЗначениеВРеквизитФормы(КЗ.Значение, КЗ.Ключ);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАвтоНаСервере(ПараметрыЗаполнения = Неопределено)
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", Объект.Организация);
	ПараметрыОтчета.Вставить("УникальныйИдентификаторФормы", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("ПараметрыЗаполнения", ПараметрыЗаполнения);
	
	ИДОтчета = ИДОтчета(ИмяФормы);
	ИДФормыОтчета = ИДФормыОтчета(ИмяФормы);
	Контейнер = НовыйКонтейнерДляАвтозаполнения();
	РегламентированнаяОтчетностьПереопределяемый.ЗаполнитьОтчет(ИДОтчета, ИДФормыОтчета, ПараметрыОтчета, Контейнер);
	ЗагрузитьПодготовленныеДанные(Контейнер);
	
КонецПроцедуры

&НаСервере
Функция НовыйКонтейнерДляАвтозаполнения()
	
	Контейнер = Новый Структура;
	Для Каждого КЗ Из ДанныеУведомления Цикл
		Контейнер.Вставить(КЗ.Ключ, ОбщегоНазначения.СкопироватьРекурсивно(КЗ.Значение));
	КонецЦикла;
	
	Возврат Контейнер;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные(Контейнер)
	
	Для Каждого КЗ Из Контейнер Цикл
		Если ДанныеУведомления.Свойство(КЗ.Ключ) Тогда
			ЗаполнитьЗначенияСвойств(ДанныеУведомления[КЗ.Ключ], КЗ.Значение);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДС = Отчеты[Объект.ИмяОтчета].СформироватьДеревоСтраниц(Объект.ИмяФормы);
	ЗначениеВРеквизитФормы(ДС, "ДеревоСтраниц");
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета)
	
	ПредставлениеУведомления.Очистить();
	ПредставлениеУведомления.Вывести(УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетТабличногоДокумента(ЭтотОбъект, ИмяМакета));
	
	Если НЕ ОбщегоНазначения.РежимОтладки()
	   И ПредставлениеУведомления.Области.Найти("СкрытьПриОткрытии") <> Неопределено Тогда
		СкрываемаяОбласть = ПредставлениеУведомления.Область("СкрытьПриОткрытии");
		СкрываемаяОбласть.Видимость = Ложь;
	КонецЕсли;
	
	СтрДанных = ДанныеУведомления[ТекущееИДНаименования];
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
		   И Обл.СодержитЗначение Тогда
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
	УведомлениеОСпецрежимахНалогообложения.ПозиционироватьсяНаЯчейке(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	СохраняемыеСведения = Новый Структура;
	СохраняемыеСведения.Вставить("ДанныеУведомления", ДанныеУведомления);
	СохраняемыеСведения.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СохраняемыеСведения.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	СохраняемыеСведения.Вставить("МногострочныеЧасти", Новый Структура);
	СохраняемыеСведения.МногострочныеЧасти.Вставить(
		"МногострочнаяЧастьП010707", РеквизитФормыВЗначение("МногострочнаяЧастьП010707"));
	СохраняемыеСведения.МногострочныеЧасти.Вставить(
		"МногострочнаяЧастьА010200", РеквизитФормыВЗначение("МногострочнаяЧастьА010200"));
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СохраняемыеСведения);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтотОбъект);
	
	Модифицированность = Ложь;
	Заголовок = СтрЗаменить(Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	
	СохраненныеСведения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаДанные, "ДанныеУведомления").Получить();
	ДанныеУведомления = СохраненныеСведения.ДанныеУведомления;
	ЗначениеВРеквизитФормы(СохраненныеСведения.ДеревоСтраниц, "ДеревоСтраниц");
	СохраненныеСведения.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Для Каждого МСЧ Из СохраненныеСведения.МногострочныеЧасти Цикл
		ПолноеИмяМСЧ = МСЧ.Ключ;
		ТаблицаМСЧ = МСЧ.Значение;
		Если ТаблицаМСЧ.Количество() = 0 Тогда
			ТаблицаМСЧ.Добавить();
		КонецЕсли;
		ЭтотОбъект[ПолноеИмяМСЧ].Загрузить(ТаблицаМСЧ);
	КонецЦикла;
	
	// В ранее сохраненных заявлениях могут отсутствовать показатели, добавившиеся в новых редакциях заявления.
	ДобавитьНедостающиеПоказатели();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНедостающиеПоказатели()
	
	Лист002 = ДанныеУведомления.Лист002;
	
	Если НЕ Лист002.Свойство("ПД1070100") Тогда
		Лист002.Вставить("ПД1070100", "");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЭтоОбластьОКСМ(Область)
	
	Если Область.Имя = "П01050100" И ТекущееИДНаименования = "Лист001" Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	СохранитьДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораСтраныЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		КодЭлементаСправочника = УведомлениеОСпецрежимахНалогообложенияВызовСервера.РеквизитЭлементаСправочника(Результат, "Код");
		Область = ДополнительныеПараметры.Область;
		Если Область.Значение <> КодЭлементаСправочника Тогда
			Область.Значение = КодЭлементаСправочника;
			Модифицированность = Истина;
		КонецЕсли;
		ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элементы.ПредставлениеУведомления, Область);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыОповещения = Новый Структура("Организация, ВидУведомления", Объект.Организация, Объект.ВидУведомления);
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыОповещения, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выгрузка = Выгрузка[0];
	СтруктураВыгрузки = Новый Структура("ТестВыгрузки,КодировкаВыгрузки", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки);
	СтруктураВыгрузки.Вставить("Данные", УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетДвоичныхДанных(Объект.ИмяОтчета, "TIFF_2024_1"));
	СтруктураВыгрузки.Вставить("ИмяФайла", "1112501_5.03000_07.tif");
	Возврат СтруктураВыгрузки;
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

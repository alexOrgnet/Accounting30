﻿#Область ОбработчикиСобытийФормы

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

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗапросСведенийСоставляющихНалоговуюТайну;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2019_1");
	
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
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	Заголовок = УведомлениеОСпецрежимахНалогообложения.ДополнитьЗаголовокУведомления(Заголовок, Объект.Организация);
	ЭтоЮрЛицо = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
	УведомлениеОСпецрежимахНалогообложения.СпрятатьКнопкиВыгрузкиОтправкиУНеактуальныхФорм(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтотОбъект, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РучнойВвод = Ложь;
	Элементы.ФормаРучнойВвод.Пометка = Ложь;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	ЗаполнитьНачальныеДанные();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", Объект.ДатаПодписи);
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда
		СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННЮЛ);
		ДанныеУведомленияТитульный.Вставить("НаимОрг", СведенияОбОрганизации.НаимЮЛПол);
		ДанныеУведомленияТитульный.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелОрганизации);
		ДанныеУведомленияТитульный.Вставить("ПрОбъекта", "организация");
	Иначе
		СтрокаСведений = "ИННФЛ,ФИО,ТелДом,ФамилияИП,ИмяИП,ОтчествоИП";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННФЛ);
		ДанныеУведомленияТитульный.Вставить("Фамилия", СведенияОбОрганизации.ФамилияИП);
		ДанныеУведомленияТитульный.Вставить("Имя", СведенияОбОрганизации.ИмяИП);
		ДанныеУведомленияТитульный.Вставить("Отчество", СведенияОбОрганизации.ОтчествоИП);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелДом);
		ДанныеУведомленияТитульный.Вставить("ПрОбъекта", "индивидуальный предприниматель");
	КонецЕсли;
	
	Реквизиты = РегистрацияВНОСервер.ДанныеРегистрации(Объект.РегистрацияВИФНС);
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	ДанныеУведомленияТитульный.Вставить("КПП", Реквизиты.КПП);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоФизЛицу(ЭтотОбъект);
	Иначе
		УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоОрганизации(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	Стр001.МакетыПФ = "Печать_Форма2019_1_Титульная";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Сведения об"+символы.ПС+"объекте сведений";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Лист002";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист002";
	Стр001.МакетыПФ = "Печать_Форма2019_1_Лист002";
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
	ДоступностьДанныхНаЛисте002();
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета)
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюСтраницу(ЭтотОбъект, ИмяМакета, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьДанныхНаЛисте002()
	ОблПрОбъекта = ПредставлениеУведомления.Области.Найти("ПрОбъекта");
	Если ОблПрОбъекта = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	ПрОбъекта = ОблПрОбъекта.Значение;
	
	Если ПрОбъекта = "организация" Тогда 
		ПредставлениеУведомления.Области["КПП"].Защита = Ложь;
		ПредставлениеУведомления.Области["КПП"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		ПредставлениеУведомления.Области["НаимОрг"].Защита = Ложь;
		ПредставлениеУведомления.Области["НаимОрг"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "Фамилия");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "Имя");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "Отчество");
		
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "КодВидДок");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "СерНомДок");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "ДатаДок");
	ИначеЕсли ПрОбъекта = "индивидуальный предприниматель" Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "НаимОрг");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "КПП");
		
		ПредставлениеУведомления.Области["Фамилия"].Защита = Ложь;
		ПредставлениеУведомления.Области["Имя"].Защита = Ложь;
		ПредставлениеУведомления.Области["Отчество"].Защита = Ложь;
		ПредставлениеУведомления.Области["Фамилия"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		ПредставлениеУведомления.Области["Имя"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		ПредставлениеУведомления.Области["Отчество"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "КодВидДок");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "СерНомДок");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "ДатаДок");
	ИначеЕсли ПрОбъекта = "физическое лицо" Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "НаимОрг");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "КПП");
		
		ПредставлениеУведомления.Области["Фамилия"].Защита = Ложь;
		ПредставлениеУведомления.Области["Имя"].Защита = Ложь;
		ПредставлениеУведомления.Области["Отчество"].Защита = Ложь;
		ПредставлениеУведомления.Области["Фамилия"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		ПредставлениеУведомления.Области["Имя"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		ПредставлениеУведомления.Области["Отчество"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		
		ПредставлениеУведомления.Области["КодВидДок"].Защита = Ложь;
		ПредставлениеУведомления.Области["СерНомДок"].Защита = Ложь;
		ПредставлениеУведомления.Области["ДатаДок"].Защита = Ложь;
		ПредставлениеУведомления.Области["КодВидДок"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		ПредставлениеУведомления.Области["СерНомДок"].ЦветФона = ЭтотОбъект["ЦФЖ"];
		ПредставлениеУведомления.Области["ДатаДок"].ЦветФона = ЭтотОбъект["ЦФЖ"];
	Иначе
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "НаимОрг");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "КПП");
		
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "Фамилия");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "Имя");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "Отчество");
		
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "КодВидДок");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "СерНомДок");
		УведомлениеОСпецрежимахНалогообложенияКлиент.ЗащитаОбласти(ЭтотОбъект, "ДатаДок");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = РегистрацияВНОСервер.ДанныеРегистрации(Объект.РегистрацияВИФНС);
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	ПредставлениеУведомления.Области["КПП"].Значение = Реквизиты.КПП;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоФизЛицу(ЭтотОбъект);
	Иначе
		УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоОрганизации(ЭтотОбъект);
	КонецЕсли;
	
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение);
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
	ДанныеУведомленияТитульный.Вставить("КПП", ПредставлениеУведомления.Области["КПП"].Значение);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	Заголовок = СтрЗаменить(Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	СтруктураПараметров = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаДанные, "ДанныеУведомления").Получить();
	ДанныеУведомления = СтруктураПараметров.ДанныеУведомления;
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораПрОбъекта(Область, СтандартнаяОбработка)
	ПрОбъекта = Область.Значение;
	
	Если ТекущееИДНаименования = "Лист002" Тогда 
		Если ПрОбъекта = "организация" Тогда 
			Область.Значение = "индивидуальный предприниматель";
		ИначеЕсли ПрОбъекта = "индивидуальный предприниматель" Тогда
			Область.Значение = "физическое лицо";
		Иначе
			Область.Значение = "организация";
		КонецЕсли;
	Иначе
		Если ЭтоЮрЛицо Тогда
			Область.Значение = "организация";
		Иначе
			Если ПрОбъекта = "физическое лицо" Тогда 
				Область.Значение = "индивидуальный предприниматель";
			Иначе
				Область.Значение = "физическое лицо";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеУведомления[ТекущееИДНаименования].ПрОбъекта = Область.Значение;
	ПрОбъекта = Область.Значение;
	Если ПрОбъекта = "организация" Тогда 
		ПредставлениеУведомления.Области["Фамилия"].Значение = Неопределено;
		ПредставлениеУведомления.Области["Имя"].Значение = Неопределено;
		ПредставлениеУведомления.Области["Отчество"].Значение = Неопределено;
		ПредставлениеУведомления.Области["КодВидДок"].Значение = Неопределено;
		ПредставлениеУведомления.Области["СерНомДок"].Значение = Неопределено;
		ПредставлениеУведомления.Области["ДатаДок"].Значение = Неопределено;
		
		ДанныеУведомления[ТекущееИДНаименования]["Фамилия"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["Имя"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["Отчество"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["КодВидДок"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["СерНомДок"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["ДатаДок"] = Неопределено;
	ИначеЕсли ПрОбъекта = "индивидуальный предприниматель" Тогда
		ПредставлениеУведомления.Области["КПП"].Значение = Неопределено;
		ПредставлениеУведомления.Области["КодВидДок"].Значение = Неопределено;
		ПредставлениеУведомления.Области["СерНомДок"].Значение = Неопределено;
		ПредставлениеУведомления.Области["ДатаДок"].Значение = Неопределено;
		ПредставлениеУведомления.Области["НаимОрг"].Значение = Неопределено;
		
		ДанныеУведомления[ТекущееИДНаименования]["КПП"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["КодВидДок"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["СерНомДок"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["ДатаДок"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["НаимОрг"] = Неопределено;
	ИначеЕсли ПрОбъекта = "физическое лицо" Тогда
		ПредставлениеУведомления.Области["КПП"].Значение = Неопределено;
		ПредставлениеУведомления.Области["НаимОрг"].Значение = Неопределено;
		
		ДанныеУведомления[ТекущееИДНаименования]["КПП"] = Неопределено;
		ДанныеУведомления[ТекущееИДНаименования]["НаимОрг"] = Неопределено;
	КонецЕсли;
	
	ДоступностьДанныхНаЛисте002();
	СтандартнаяОбработка = Ложь;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если Область.Имя = "ПрОбъекта" Тогда
		ОбработкаВыбораПрОбъекта(Область, СтандартнаяОбработка);
		Возврат;
	ИначеЕсли СтрДлина(Область.Имя) = 7 И СтрНачинаетсяС(Область.Имя, "Код") Тогда 
		Область.Значение = ?(ЗначениеЗаполнено(Область.Значение), "", "V");
		ДанныеУведомления[ТекущееИДНаименования][Область.Имя] = Область.Значение;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	КонецЕсли;
	
	Если УведомлениеОСпецрежимахНалогообложенияКлиент.ТиповойВыбор(ЭтотОбъект, Область, СтандартнаяОбработка) Или РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
	
	Если Область.Имя = "КодНО" Тогда 
		СтандартнаяОбработка = Ложь;
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Область.Имя);
	ИначеЕсли СтандартнаяОбработка И Область.Защита = Ложь Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПодписантаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОткрытьФормуВыбораПодписантаЗавершение(ЭтотОбъект, Результат);
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

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

#КонецОбласти

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПроверитьВыгрузку(ЭтотОбъект, ПроверитьВыгрузкуНаСервере());
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, "Открыть", Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура РазрешитьРедактированиеРеквизитовОбъекта() Экспорт
	РегламентированнаяОтчетность.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	РегламентированнаяОтчетностьКлиент.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры

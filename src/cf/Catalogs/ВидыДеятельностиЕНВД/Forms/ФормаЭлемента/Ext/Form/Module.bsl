﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ВладелецЮрЛицо  = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Объект.Владелец);
	КонецЕсли;
	
	ИспользуетсяНесколькоОрганизаций = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
	Элементы.Владелец.Видимость        = Не ЗначениеЗаполнено(Объект.Владелец) И ИспользуетсяНесколькоОрганизаций;
	Элементы.ВладелецНадпись.Видимость = ЗначениеЗаполнено(Объект.Владелец) И ИспользуетсяНесколькоОрганизаций;
	
	ВидКонтактнойИнформацииАдреса = Справочники.ВидыДеятельностиЕНВД.ВидКонтактнойИнформацииАдреса();
	
	Если Не ПустаяСтрока(Объект.Адрес) Тогда
		АдресМестаОсуществленияДеятельности = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Объект.Адрес);
	Иначе
		АдресМестаОсуществленияДеятельности = УправлениеКонтактнойИнформациейКлиентСервер.ТекстПустогоАдресаВВидеГиперссылки();
	КонецЕсли;
	
	Период = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	ПрочитатьЗначенияРеквизитовФормы();
	
	ПрочитатьРегистрациюВНалоговомОргане();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Модифицированность = Истина;
		
		ЗаполнитьЗначенияСвойств(РегистрацияВНалоговомОргане, ВыбранноеЗначение);
		Если ВыбранноеЗначение.Свойство("Представитель") Тогда
			ОтчетностьПодписываетПредставитель = ?(ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Представитель), 1, 0);
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если РегистрацияВНалоговомОргане.Ссылка.Пустая() И Не ПустаяСтрока(РегистрацияВНалоговомОргане.Код) Тогда
		
		// При записи будет создана новая регистрация
		ТекущийОбъект.РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.ПолучитьСсылку(УникальныйИдентификатор);
		
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не РегистрацияВНалоговомОргане.Ссылка.Пустая() Или Не ПустаяСтрока(РегистрацияВНалоговомОргане.Код) Тогда
		
		РегистрацияВНалоговомОрганеОбъект = РеквизитФормыВЗначение("РегистрацияВНалоговомОргане");
		
		Если Не РегистрацияВНалоговомОргане.Ссылка.Пустая() Тогда
			РегистрацияВНалоговомОрганеОбъект.Заблокировать();
		Иначе
			РегистрацияВНалоговомОрганеОбъект.УстановитьСсылкуНового(ТекущийОбъект.РегистрацияВНалоговомОргане);
		КонецЕсли;
		
		РегистрацияВНалоговомОрганеОбъект.Владелец = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(ТекущийОбъект.Владелец);
		РегистрацияВНалоговомОрганеОбъект.Записать();
		
		ЗначениеВРеквизитФормы(РегистрацияВНалоговомОрганеОбъект, "РегистрацияВНалоговомОргане");
		
	КонецЕсли;
	
	ПериодТекущихЗначений = ?(Объект.Ссылка.Пустая(), Объект.ДатаНачала, Период);
	
	// Физический показатель
	ФизическиеПоказателиЕНВДКлючЗаписи = РегистрыСведений.ФизическиеПоказателиЕНВД.СоздатьКлючЗаписи(
		Новый Структура("Организация, ВидДеятельности", ТекущийОбъект.Владелец, ТекущийОбъект.Ссылка));
	ЗаблокироватьДанныеДляРедактирования(ФизическиеПоказателиЕНВДКлючЗаписи);
	РегистрыСведений.ФизическиеПоказателиЕНВД.ЗаписатьФизическийПоказатель(
		ФизическийПоказатель, ФизическиеПоказателиЕНВДКлючЗаписи, ПериодТекущихЗначений);
	ПараметрыЗаписи.Вставить("ФизическиеПоказателиЕНВДКлючЗаписи", ФизическиеПоказателиЕНВДКлючЗаписи);
	
	// Корректирующий коэффициент, Налоговая ставка
	РегиональныеОсобенностиЕНВДКлючЗаписи = РегистрыСведений.РегиональныеОсобенностиЕНВД.СоздатьКлючЗаписи(
		Новый Структура("Организация, ВидДеятельности", ТекущийОбъект.Владелец, ТекущийОбъект.Ссылка));
	ЗаблокироватьДанныеДляРедактирования(РегиональныеОсобенностиЕНВДКлючЗаписи);
	РегистрыСведений.РегиональныеОсобенностиЕНВД.ЗаписатьРегиональныеОсобенности(
		КорректирующийКоэффициент, НалоговаяСтавка, РегиональныеОсобенностиЕНВДКлючЗаписи, ПериодТекущихЗначений);
	ПараметрыЗаписи.Вставить("РегиональныеОсобенностиЕНВДКлючЗаписи", РегиональныеОсобенностиЕНВДКлючЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.РегистрацияВНалоговомОргане) Тогда
		ОповеститьОбИзменении(Объект.РегистрацияВНалоговомОргане);
	КонецЕсли;
	
	ОповеститьОбИзменении(ПараметрыЗаписи.ФизическиеПоказателиЕНВДКлючЗаписи);
	ОповеститьОбИзменении(ПараметрыЗаписи.РегиональныеОсобенностиЕНВДКлючЗаписи);
	
	Оповестить("ИзмененВидДеятельностиОрганизации", Объект.Владелец, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не РегистрацияПоМестуНахожденияОрганизации И ПустаяСтрока(Объект.Адрес) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Адрес места осуществления деятельности'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "АдресМестаОсуществленияДеятельности", , Отказ);
	КонецЕсли;
	
	Если БухгалтерскийУчетПереопределяемый.ВестиУчетПоПодразделениям() Тогда
		ТекстОшибки = "";
		Если Не Справочники.ВидыДеятельностиЕНВД.ПодразделениеЗаполненоКорректно(
				Объект.Ссылка, Объект.Владелец, Объект.Подразделение, РегистрацияВНалоговомОргане.Код, ТекстОшибки) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Корректность", "Подразделение") + ТекстОшибки;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Подразделение", "Объект", Отказ);
		КонецЕсли;
	КонецЕсли;
	
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
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ВладелецОбработатьИзменение();
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаДеятельностиПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.КодВидаДеятельности) Тогда
		
		СвойстваКодаВидаДеятельности = СвойстваКодаВидаДеятельности(Объект.КодВидаДеятельности);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СвойстваКодаВидаДеятельности);
		
		Объект.Наименование = СвойстваКодаВидаДеятельности.Наименование
			+ ОкончаниеНаименования(Объект.КодВидаДеятельности, Объект.Владелец, Объект.Ссылка);
		
		Если ЗначениеЗаполнено(Объект.Владелец) И РегистрацияПоМестуНахожденияОрганизации Тогда
			
			КодНалоговогоОрганаПоМестуНахожденияОрганизации = КодНалоговогоОрганаПоМестуНахождения(Объект.Владелец);
			Если Не ПустаяСтрока(КодНалоговогоОрганаПоМестуНахожденияОрганизации)
				И РегистрацияВНалоговомОргане.Код <> КодНалоговогоОрганаПоМестуНахожденияОрганизации Тогда
				
				РегистрацияВНалоговомОргане.Код = КодНалоговогоОрганаПоМестуНахожденияОрганизации;
				ЗаполнитьРегистрациюВНалоговомОрганеПоКоду();
				
			КонецЕсли;
			
		КонецЕсли;
		
		УправлениеФормой(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресМестаОсуществленияДеятельностиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = УправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ВидКонтактнойИнформацииАдреса,
		Объект.Адрес,
		?(Не ПустаяСтрока(Объект.Адрес), АдресМестаОсуществленияДеятельности, ""));
	
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Адрес места осуществления предпринимательской деятельности'"));
	
	Оповещение = Новый ОписаниеОповещения("АдресМестаОсуществленияДеятельностиНажатиеЗавершение", ЭтотОбъект);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, Элемент, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресМестаОсуществленияДеятельностиНажатиеЗавершение(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	Объект.Адрес = Результат.Значение;
	
	Если Не ПустаяСтрока(Объект.Адрес) Тогда
		АдресМестаОсуществленияДеятельности = Результат.Представление;
		
		СведенияОНалоговомОргане = СведенияОНалоговомОрганеПоАдресу(Объект.Адрес, ВладелецЮрЛицо);
		Если СведенияОНалоговомОргане <> Неопределено Тогда
			
			Если ЗначениеЗаполнено(СведенияОНалоговомОргане.КодПоОКТМО) Тогда
				Объект.КодПоОКТМО = СведенияОНалоговомОргане.КодПоОКТМО;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СведенияОНалоговомОргане.КодНалоговогоОргана) Тогда
				
				Если НЕ ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Код) Тогда
					
					РегистрацияВНалоговомОргане.Код = СведенияОНалоговомОргане.КодНалоговогоОргана;
					ЗаполнитьРегистрациюВНалоговомОрганеПоКоду(Истина);
					
				ИначеЕсли РегистрацияВНалоговомОргане.Код <> СведенияОНалоговомОргане.КодНалоговогоОргана Тогда
					
					ТекстВопроса = СтрШаблон(НСтр("ru = 'Выбранный адрес обслуживается налоговой инспекцией с кодом %1.
						|Заменить налоговую инспекцию?'"), СведенияОНалоговомОргане.КодНалоговогоОргана);
					ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьРеквизитыНалоговойИнспекцииПоКодуЗавершение",
						ЭтотОбъект, СведенияОНалоговомОргане.КодНалоговогоОргана);
					ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		АдресМестаОсуществленияДеятельности = УправлениеКонтактнойИнформациейКлиентСервер.ТекстПустогоАдресаВВидеГиперссылки();
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыНалоговойИнспекцииПоКодуЗавершение(РезультатыЗакрытия, КодНалоговогоОргана) Экспорт
	
	Если РезультатыЗакрытия = КодВозвратаДиалога.Да Тогда
		РегистрацияВНалоговомОргане.Код = КодНалоговогоОргана;
		ЗаполнитьРегистрациюВНалоговомОрганеПоКоду(Истина);
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПрекращенияПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#Область ГруппаНалоговыйОрган

&НаКлиенте
Процедура РегистрацияВНалоговомОрганеКПППриИзменении(Элемент)
	
	ЗаполнитьРегистрациюВНалоговомОрганеПоКоду();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КодНалоговогоОрганаПриИзменении(Элемент)
	
	ЗаполнитьРегистрациюВНалоговомОрганеПоКоду();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияВНалоговомОрганеНаименованиеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияВНалоговомОрганеНаименованиеИФНСПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежныеРеквизитыФНСПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидГосударственногоОргана", ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.НалоговыйОрган"));
	ПараметрыФормы.Вставить("КодГосударственногоОргана", РегистрацияВНалоговомОргане.Код);
	ПараметрыФормы.Вставить("НаименованиеГосударственногоОргана", РегистрацияВНалоговомОргане.НаименованиеИФНС);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ТолькоПросмотр);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзменениеПлатежныхРеквизитовФНС", ЭтотОбъект, ПараметрыФормы);
	
	ОткрытьФорму("Справочник.Контрагенты.Форма.ПлатежныеРеквизитыГосударственныхОрганов", ПараметрыФормы, ЭтотОбъект, ЭтотОбъект, , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеПлатежныхРеквизитовФНС(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Истина Тогда
		
		ПлатежныеРеквизитыФНС = ПредставлениеПлатежныхРеквизитовФНС(ДополнительныеПараметры.КодГосударственногоОргана);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетностьПодписываетПредставительПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	Если ОтчетностьПодписываетПредставитель = 0 Тогда
		РегистрацияВНалоговомОргане.Представитель = Неопределено;
		РегистрацияВНалоговомОргане.УполномоченноеЛицоПредставителя = "";
		РегистрацияВНалоговомОргане.ДокументПредставителя = "";
		РегистрацияВНалоговомОргане.Доверенность = "";
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПредставителяНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЗначенияЗаполнения = Новый Структура("Владелец, Представитель, УполномоченноеЛицоПредставителя, ДокументПредставителя, Доверенность");
	ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, РегистрацияВНалоговомОргане);
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	ОткрытьФорму("Справочник.РегистрацииВНалоговомОргане.Форма.ФормаПредставителя", ПараметрыФормы, ЭтотОбъект, КлючУникальности);
	
КонецПроцедуры

#КонецОбласти

#Область ГруппаРасчетНалога

&НаКлиенте
Процедура ФизическийПоказательПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КорректирующийКоэффициентПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговаяСтавкаПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПостановкаНаУчетОрганизации(Команда)
	
	СоздатьЗаявление(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПостановкаНаУчетИП(Команда)
	
	СоздатьЗаявление(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2"));
	
КонецПроцедуры

&НаКлиенте
Процедура СнятиеСУчетаОрганизации(Команда)
	
	СоздатьЗаявление(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3"));
	
КонецПроцедуры

&НаКлиенте
Процедура СнятиеСУчетаИП(Команда)
	
	СоздатьЗаявление(ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4"));
	
КонецПроцедуры

#Область ГруппаНалоговыйОрган

&НаКлиенте
Процедура ЗаполнитьРеквизитыНалоговогоОрганаПоКоду(Команда)
	
	Перем ОписаниеОшибки;
	
	Если Не ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Код) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Код инспекции"" не заполнено'"), , "РегистрацияВНалоговомОргане.Код");
		ТекущийЭлемент = Элементы.КодНалоговогоОргана;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРегистрациюВНалоговомОрганеПоКоду(Истина, ОписаниеОшибки);
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		
		Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
			
			ТекстВопроса = НСтр("ru='Для автоматического заполнения реквизитов контрагентов
				|необходимо подключиться к Интернет-поддержке пользователей.
				|Подключиться сейчас?'");
			
			ПараметрыВопроса = Новый Структура("ВызовПослеПодключения", "ЗаполнитьСведенияОНалоговойИнспекцииПоКоду");
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект, ПараметрыВопроса);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			
		Иначе
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ГруппаРасчетНалога

&НаКлиенте
Процедура ФизическийПоказательИстория(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ОтборНабораЗаписей = Новый Структура;
	ОтборНабораЗаписей.Вставить("Организация", Объект.Владелец);
	ОтборНабораЗаписей.Вставить("ВидДеятельности", Объект.Ссылка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ОтборНабораЗаписей);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ФизическийПоказательИсторияЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.ФизическиеПоказателиЕНВД.Форма.ФормаИстории", ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическийПоказательИсторияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПрочитатьЗначенияРеквизитовФормы("ФизическийПоказатель");
	
	Оповестить("ИзмененВидДеятельностиОрганизации", Объект.Владелец, ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РегиональныеОсобенностиИстория(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ОтборНабораЗаписей = Новый Структура;
	ОтборНабораЗаписей.Вставить("Организация", Объект.Владелец);
	ОтборНабораЗаписей.Вставить("ВидДеятельности", Объект.Ссылка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", ОтборНабораЗаписей);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("РегиональныеОсобенностиИсторияЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.РегиональныеОсобенностиЕНВД.Форма.ФормаИстории", ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура РегиональныеОсобенностиИсторияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПрочитатьЗначенияРеквизитовФормы("КорректирующийКоэффициент, НалоговаяСтавка");
	
	Оповестить("ИзмененВидДеятельностиОрганизации", Объект.Владелец, ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект  = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.КодВидаДеятельности.Подсказка = Форма.НаименованиеПолное;
	
	РегистрацияПоМестуОсуществленияДеятельности = ЗначениеЗаполнено(Объект.КодВидаДеятельности)
		И Не Форма.РегистрацияПоМестуНахожденияОрганизации;
	
	Элементы.АдресМестаОсуществленияДеятельности.Видимость = РегистрацияПоМестуОсуществленияДеятельности;
	Элементы.КодПоОКТМО.Видимость = РегистрацияПоМестуОсуществленияДеятельности;
	
	// ГруппаСоздатьЗаявление
	
	Элементы.ФормаПостановкаНаУчетОрганизации.Видимость = Форма.ВладелецЮрЛицо;
	Элементы.ФормаПостановкаНаУчетИП.Видимость = Не Форма.ВладелецЮрЛицо;
	Элементы.ФормаСнятиеСУчетаОрганизации.Видимость = Форма.ВладелецЮрЛицо;
	Элементы.ФормаСнятиеСУчетаИП.Видимость = Не Форма.ВладелецЮрЛицо;
	
	// ГруппаНалоговыйОрган
	
	КодНалоговогоОрганаУказан = ЗначениеЗаполнено(Форма.РегистрацияВНалоговомОргане.Код);
	
	Элементы.РегистрацияВНалоговомОрганеНаименование.Доступность = КодНалоговогоОрганаУказан;
	Элементы.РегистрацияВНалоговомОрганеНаименованиеИФНС.Доступность = КодНалоговогоОрганаУказан;
	Элементы.ПлатежныеРеквизитыФНСПредставление.Доступность = КодНалоговогоОрганаУказан;
	Элементы.РегистрацияВНалоговомОрганеКПП.Видимость = Форма.ВладелецЮрЛицо;
	Элементы.РегистрацияВНалоговомОрганеКПП.Доступность = КодНалоговогоОрганаУказан;
	Элементы.ОтчетностьПодписываетПредставитель.Доступность = КодНалоговогоОрганаУказан;
	Элементы.ПредставлениеПредставителя.Доступность = КодНалоговогоОрганаУказан;
	
	Элементы.НадписьПредставительНеВыбран.Видимость = (Форма.ОтчетностьПодписываетПредставитель = 0);
	Элементы.ПредставлениеПредставителя.Видимость   = (Форма.ОтчетностьПодписываетПредставитель = 1);
	Форма.ПредставлениеПредставителя = ПредставлениеГиперссылкиПредставитель(Форма.РегистрацияВНалоговомОргане);
	
	Элементы.ГруппаНалоговыйОрган.ЗаголовокСвернутогоОтображения = ЗаголовокГруппыНалоговыйОрган(Форма);
	
	// ГруппаРасчетНалога
	
	Элементы.ФизическийПоказатель.Заголовок = Форма.ИмяФизическогоПоказателя;
	Элементы.ФизическийПоказатель.РасширеннаяПодсказка.Заголовок = Форма.ПодсказкаФизическогоПоказателя;
	
	Элементы.ГруппаРасчетНалога.ЗаголовокСвернутогоОтображения = ЗаголовокГруппыРасчетНалога(Форма);
	
	РассчитатьСуммуНалога(Форма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "АдресМестаОсуществленияДеятельности");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Адрес", ВидСравненияКомпоновкиДанных.Равно, "");
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненныйРеквизит);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявление(ВидЗаявления)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ВидыДеятельности", ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Объект.Владелец);
	ПараметрыФормы.Вставить("НалоговыйОрган", Объект.РегистрацияВНалоговомОргане);
	ПараметрыФормы.Вставить("ПараметрыЗаполнения", ПараметрыЗаполнения);
	ПараметрыФормы.Вставить("СформироватьФормуОтчетаАвтоматически", Истина);
	
	УчетЕНВДКлиент.ОткрытьФормуЗаявления(ВидЗаявления, ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ВладелецОбработатьИзменение()
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ВладелецЮрЛицо  = ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(Объект.Владелец);
	КонецЕсли;
	
	Если РегистрацияВНалоговомОргане.Владелец <> Объект.Владелец Тогда
		Объект.РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
	КонецЕсли;
	
	ПрочитатьЗначенияРеквизитовФормы("ФизическийПоказатель, КорректирующийКоэффициент, НалоговаяСтавка");
	
	ПрочитатьРегистрациюВНалоговомОргане();
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СвойстваКодаВидаДеятельности(Знач КодВидаДеятельности)
	
	ИменаСвойств = "Наименование, НаименованиеПолное, РегистрацияПоМестуНахожденияОрганизации,
		|БазоваяДоходность, ИмяФизическогоПоказателя, ПодсказкаФизическогоПоказателя";
	
	Если ЗначениеЗаполнено(КодВидаДеятельности) Тогда
		Свойства = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КодВидаДеятельности, ИменаСвойств);
	Иначе
		Свойства = Новый Структура(ИменаСвойств);
		Свойства.Наименование = "";
		Свойства.НаименованиеПолное = "";
		Свойства.РегистрацияПоМестуНахожденияОрганизации = Ложь;
		Свойства.БазоваяДоходность = 0;
		Свойства.ИмяФизическогоПоказателя = НСтр("ru = 'Физический показатель'");
		Свойства.ПодсказкаФизическогоПоказателя = "";
	КонецЕсли;
	
	Возврат Свойства;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОкончаниеНаименования(Знач КодВидаДеятельности, Знач Владелец, Знач Ссылка)
	
	МаксимальныйИндекс = Справочники.ВидыДеятельностиЕНВД.МаксимальныйИндексВидаДеятельности(КодВидаДеятельности, Владелец, Ссылка);
	Если МаксимальныйИндекс = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	ИндексНаименования = МаксимальныйИндекс + 1;
	
	Возврат " " + ИндексНаименования;
	
КонецФункции

#Область СлужебныеПроцедурыИФункции_НалоговыйОрган

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокГруппыНалоговыйОрган(Форма)
	
	Объект = Форма.Объект;
	
	ЗаголовокПоУмолчанию = НСтр("ru = 'Налоговая инспекция'");
	
	Если ЗначениеЗаполнено(Форма.РегистрацияВНалоговомОргане.Код) Тогда
		
		Заголовок = СтрШаблон(НСтр("ru = '%1: %2 %3'"),
			ЗаголовокПоУмолчанию,
			Форма.РегистрацияВНалоговомОргане.Код,
			Форма.РегистрацияВНалоговомОргане.Наименование)
		
	Иначе
		
		Заголовок = ЗаголовокПоУмолчанию;
		
	КонецЕсли;
	
	Возврат Заголовок;
	
КонецФункции

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Оповещение);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Перем ВызовПослеПодключения, ОписаниеОшибки;
	
	Если Результат <> Неопределено
		И ДополнительныеПараметры.Свойство("ВызовПослеПодключения", ВызовПослеПодключения)
		И ВызовПослеПодключения = "ЗаполнитьСведенияОНалоговойИнспекцииПоКоду" Тогда
		
		ЗаполнитьРегистрациюВНалоговомОрганеПоКоду(Истина, ОписаниеОшибки);
		Если Не ПустаяСтрока(ОписаниеОшибки) Тогда
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СведенияОНалоговомОрганеПоАдресу(Адрес, ВладелецЮрЛицо)
	
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СведенияОНалоговомОрганеПоАдресу = АдресныйКлассификатор.КодыАдреса(Адрес, "Сервис1С");
	
	КодНалоговогоОрганаПоАдресу = ?(ВладелецЮрЛицо, Формат(СведенияОНалоговомОрганеПоАдресу.КодИФНСЮЛ, "ЧЦ=4; ЧДЦ=; ЧВН=; ЧГ=0"),
												Формат(СведенияОНалоговомОрганеПоАдресу.КодИФНСФЛ, "ЧЦ=4; ЧДЦ=; ЧВН=; ЧГ=0"));
	
	Если ЗначениеЗаполнено(КодНалоговогоОрганаПоАдресу) Тогда
		
		Сведения = Новый Структура();
		Сведения.Вставить("КодНалоговогоОргана", КодНалоговогоОрганаПоАдресу);
		Сведения.Вставить("КодПоОКТМО", Формат(СведенияОНалоговомОрганеПоАдресу.ОКТМО, "ЧДЦ=; ЧГ=0"));
		Сведения.Вставить("КодПоОКАТО", Формат(СведенияОНалоговомОрганеПоАдресу.ОКАТО, "ЧДЦ=; ЧГ=0"));
		
		Возврат Сведения;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьРегистрациюВНалоговомОрганеПоКоду(ПерезаполнятьСведения = Ложь, ОписаниеОшибки = "")
	
	Если Не ЗначениеЗаполнено(Объект.Владелец) Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	КодНалоговогоОргана = СокрЛП(РегистрацияВНалоговомОргане.Код);
	КПП = РегистрацияВНалоговомОргане.КПП;
	
	Объект.РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
	ПрочитатьРегистрациюВНалоговомОргане();
	
	РегистрацияВНалоговомОргане.Код = КодНалоговогоОргана;
	
	Если СтрДлина(КодНалоговогоОргана) = 4 Тогда
		
		Если ВладелецЮрЛицо И ПустаяСтрока(РегистрацияВНалоговомОргане.КПП) Тогда
			КодПричиныПостановкиНаУчет = УчетЕНВД.КодПричиныПостановкиНаУчет(Объект.Владелец);
			Если ПустаяСтрока(КПП) Тогда
				ШаблонКПП = КодНалоговогоОргана + КодПричиныПостановкиНаУчет + "___";
				КППпоУмолчанию = КодНалоговогоОргана + КодПричиныПостановкиНаУчет + "001";
			Иначе
				ШаблонКПП = КПП;
				КППпоУмолчанию = КПП;
			КонецЕсли;
		Иначе
			ШаблонКПП = "";
			КППпоУмолчанию = "";
		КонецЕсли;
		
		// Ищем подходящую регистрацию в справочнике
		Объект.РегистрацияВНалоговомОргане = Справочники.РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане(
			ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Объект.Владелец), ШаблонКПП, КодНалоговогоОргана);
		
		Если ЗначениеЗаполнено(Объект.РегистрацияВНалоговомОргане) Тогда
			ПрочитатьРегистрациюВНалоговомОргане();
		КонецЕсли;
		
		Если ПустаяСтрока(РегистрацияВНалоговомОргане.КПП) Тогда
			РегистрацияВНалоговомОргане.КПП = КППпоУмолчанию;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Объект.РегистрацияВНалоговомОргане) Или ПерезаполнятьСведения Тогда
			
			РеквизитыНалоговогоОргана = ДанныеГосударственныхОрганов.РеквизитыНалоговогоОрганаПоКоду(КодНалоговогоОргана);
			
			Если ЗначениеЗаполнено(РеквизитыНалоговогоОргана.ОписаниеОшибки) Тогда
				ОписаниеОшибки = РеквизитыНалоговогоОргана.ОписаниеОшибки;
				Возврат;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(РеквизитыНалоговогоОргана.Ссылка) Тогда
				ДанныеГосударственныхОрганов.ОбновитьДанныеГосударственногоОргана(РеквизитыНалоговогоОргана);
			КонецЕсли;
			
			ПлатежныеРеквизитыФНСПредставление = ДанныеГосударственныхОрганов.ПредставлениеПлатежныхРеквизитовГосударственногоОргана(РеквизитыНалоговогоОргана);
			
			РегистрацияВНалоговомОргане.Наименование     = РеквизитыНалоговогоОргана.Наименование;
			РегистрацияВНалоговомОргане.НаименованиеИФНС = РеквизитыНалоговогоОргана.ПолноеНаименование;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеГиперссылкиПредставитель(РегистрацияВНалоговомОргане)
	
	Если ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Представитель) Тогда
		
		Если ТипЗнч(РегистрацияВНалоговомОргане.Представитель) = Тип("СправочникСсылка.ФизическиеЛица")
			Или Не ЗначениеЗаполнено(РегистрацияВНалоговомОргане.УполномоченноеЛицоПредставителя) Тогда
			
			ПредставлениеПредставителя = РегистрацияВНалоговомОргане.Представитель;
			
		Иначе
			
			ПредставлениеПредставителя = СтрШаблон("%1 (%2)",
				РегистрацияВНалоговомОргане.УполномоченноеЛицоПредставителя,
				РегистрацияВНалоговомОргане.Представитель);
			
		КонецЕсли;
		
	Иначе
		
		ПредставлениеПредставителя = НСтр("ru = 'Заполнить'");
		
	КонецЕсли;
	
	Возврат ПредставлениеПредставителя;
	
КонецФункции

&НаСервере
Процедура ПрочитатьРегистрациюВНалоговомОргане()
	
	Если ЗначениеЗаполнено(Объект.РегистрацияВНалоговомОргане) Тогда
		ЗначениеВРеквизитФормы(Объект.РегистрацияВНалоговомОргане.ПолучитьОбъект(), "РегистрацияВНалоговомОргане");
	Иначе
		ЗначениеВРеквизитФормы(Справочники.РегистрацииВНалоговомОргане.СоздатьЭлемент(), "РегистрацияВНалоговомОргане");
	КонецЕсли;
	
	ОтчетностьПодписываетПредставитель = ?(ЗначениеЗаполнено(РегистрацияВНалоговомОргане.Представитель), 1, 0);
	
	ПлатежныеРеквизитыФНСПредставление = ПредставлениеПлатежныхРеквизитовФНС(РегистрацияВНалоговомОргане.Код);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеПлатежныхРеквизитовФНС(Знач Код)
	
	Если ЗначениеЗаполнено(Код) Тогда
		ГосударственныйОрган = ДанныеГосударственныхОрганов.ГосударственныйОрган(Перечисления.ВидыГосударственныхОрганов.НалоговыйОрган, Код);
	КонецЕсли;
	
	Представление = ДанныеГосударственныхОрганов.ПредставлениеПлатежныхРеквизитовГосударственногоОргана(ГосударственныйОрган);
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_РасчетНалога

&НаКлиентеНаСервереБезКонтекста
Функция ЗаголовокГруппыРасчетНалога(Форма)
	
	Объект = Форма.Объект;
	
	Если ЗначениеЗаполнено(Объект.КодВидаДеятельности) Тогда
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(Форма.ИмяФизическогоПоказателя + " = " + Форма.ФизическийПоказатель);
		МассивСтрок.Добавить(НСтр("ru = 'Коэффициент К2 = '") + Форма.КорректирующийКоэффициент);
		МассивСтрок.Добавить(НСтр("ru = 'Ставка = '") + Форма.НалоговаяСтавка + "%");
		
		Возврат СтрСоединить(МассивСтрок, "; ");
		
	Иначе
		
		Возврат НСтр("ru = 'Расчет налога'");
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПрочитатьЗначенияРеквизитовФормы(ИменаРеквизитовСтрокой = "")
	
	Если Не ПустаяСтрока(ИменаРеквизитовСтрокой) Тогда
		ИменаРеквизитов = СтрРазделить(ИменаРеквизитовСтрокой, ",");
	КонецЕсли;
	
	Если ИменаРеквизитов = Неопределено Или ИменаРеквизитов.Найти("ФизическийПоказатель") <> Неопределено Тогда
		ФизическийПоказатель = РегистрыСведений.ФизическиеПоказателиЕНВД.ФизическийПоказательВидаДеятельности(
			Объект.Владелец, Объект.Ссылка, Период);
	КонецЕсли;
	
	Если ИменаРеквизитов = Неопределено Или ИменаРеквизитов.Найти("КоэффициентДефлятор") <> Неопределено Тогда
		КоэффициентДефлятор = УчетЕНВДКлиентСервер.КоэффициентДефлятор(Период);
	КонецЕсли;
	
	Если ИменаРеквизитов = Неопределено
		Или ИменаРеквизитов.Найти("КорректирующийКоэффициент") <> Неопределено
		Или ИменаРеквизитов.Найти("НалоговаяСтавка") <> Неопределено Тогда
		
		РегиональныеОсобенности = РегистрыСведений.РегиональныеОсобенностиЕНВД.РегиональныеОсобенностиВидаДеятельности(
			Объект.Владелец, Объект.Ссылка, Период);
		
		КорректирующийКоэффициент = РегиональныеОсобенности.КорректирующийКоэффициент;
		НалоговаяСтавка           = РегиональныеОсобенности.НалоговаяСтавка;
		
	КонецЕсли;
	
	Если ИменаРеквизитов = Неопределено
		Или ИменаРеквизитов.Найти("НаименованиеПолное") <> Неопределено
		Или ИменаРеквизитов.Найти("ИмяФизическогоПоказателя") <> Неопределено
		Или ИменаРеквизитов.Найти("ПодсказкаФизическогоПоказателя") <> Неопределено
		Или ИменаРеквизитов.Найти("БазоваяДоходность") <> Неопределено Тогда
		
		СвойстваКодаВидаДеятельности = СвойстваКодаВидаДеятельности(Объект.КодВидаДеятельности);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СвойстваКодаВидаДеятельности);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьСуммуНалога(Форма)
	
	ПараметрыРасчетаСуммыНалога = УчетЕНВДКлиентСервер.НовыеПараметрыРасчетаСуммыНалога();
	ЗаполнитьЗначенияСвойств(ПараметрыРасчетаСуммыНалога, Форма.Объект, , "ДатаНачала, ДатаПрекращения");
	ЗаполнитьЗначенияСвойств(ПараметрыРасчетаСуммыНалога, Форма);
	ПараметрыРасчетаСуммыНалога.ФизическийПоказатель1 = Форма.ФизическийПоказатель;
	ПараметрыРасчетаСуммыНалога.ФизическийПоказатель3 = Форма.ФизическийПоказатель;
	ПараметрыРасчетаСуммыНалога.ФизическийПоказатель2 = Форма.ФизическийПоказатель;
	
	Форма.ВмененныйДоход = УчетЕНВДКлиентСервер.ВмененныйДоходЗаКвартал(ПараметрыРасчетаСуммыНалога);
	Форма.СуммаНалога    = Окр(Форма.ВмененныйДоход * ПараметрыРасчетаСуммыНалога.НалоговаяСтавка / 100, 0);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КодНалоговогоОрганаПоМестуНахождения(Организация)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Организация), "КодНалоговогоОргана");
	
КонецФункции

#КонецОбласти

#КонецОбласти
﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РасчетЗарплатыДляНебольшихОрганизаций = ПолучитьФункциональнуюОпцию("РасчетЗарплатыДляНебольшихОрганизаций");
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Документы.НачислениеЗарплаты);
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Элементы.КоманднаяПанельФормы);
	// Конец БлокировкаИзмененияОбъектов
	
	// КадровыйЭДО
	КадровыйЭДО.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, Список);
	// Конец КадровыйЭДО
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервереФормыСписка(ЭтотОбъект, "Список");
	КонецЕсли;
	// Конец ПроцессыОбработкиДокументов
	
	Если ПолучитьФункциональнуюОпцию("ИнтерфейсТаксиПростой") Тогда
		ЭтотОбъект.АвтоЗаголовок = Ложь;
		ЭтотОбъект.Заголовок = НСтр("ru = 'Начисления'");
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	Иначе
		
		// СтандартныеПодсистемы.ВерсионированиеОбъектов
		ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
		// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
		
		// СтандартныеПодсистемы.ПодключаемыеКоманды
		ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
		ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаГлобальныеКоманды;
		ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
		// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
	КонецЕсли;
	
	УстановитьОтборыПриСозданииНаСервере(Параметры);
	
	СтруктураПараметровОтбора = Новый Структура();
	ЗарплатаКадры.ДобавитьПараметрОтбора(СтруктураПараметровОтбора, "ФизическоеЛицо",
		Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"), НСтр("ru = 'Сотрудник'"));
	
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список",,
		СтруктураПараметровОтбора, "СписокКритерииОтбора", "Организация", Ложь);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормаСоздатьНачисление",
		"Видимость",
		МожноРедактировать
			И НЕ РасчетЗарплатыДляНебольшихОрганизаций);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокСоздатьНачисление",
		"Видимость",
		МожноРедактировать
			И НЕ РасчетЗарплатыДляНебольшихОрганизаций);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ФормаГруппаСоздать",
		"Видимость",
		МожноРедактировать
			И РасчетЗарплатыДляНебольшихОрганизаций);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокГруппаСоздать",
		"Видимость",
		МожноРедактировать
			И РасчетЗарплатыДляНебольшихОрганизаций);
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"БП.ЖурналДокументов.НачислениеЗарплаты",
		"ФормаСписка",
		НСтр("ru = 'Новости: Все начисления'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	
	ПомеченныеНаУдалениеСервер.СкрытьПомеченныеНаУдаление(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ПоказатьПредупреждениеПревышениеЛимитаТарифа", 0.1, Истина);
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОсновнаяОрганизация = Параметр;
		Если ОсновнаяОрганизация <> ОтборОрганизация Тогда
			ОтборОрганизация                 = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
			УстановитьВосстановленныеОтборы();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Запись_Сотрудники" Или ИмяСобытия = "Запись_ПриемНаРаботу" 
		Или ИмяСобытия = "Запись_Увольнение" Или ИмяСобытия = "ИзменениеКадровыхДокументов" Тогда 
		ПодключитьОбработчикОжидания("ПоказатьПредупреждениеПревышениеЛимитаТарифа", 0.1, Истина);
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
	// КадровыйЭДО
	КадровыйЭДОКлиент.ОбработкаОповещенияВФормеСписка(
		ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ПерсонализированныеПредложенияСервисовКлиент.ПерейтиПоСсылкеБаннера(
		НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, Баннер, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СтруктураОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", СтруктураОтбора) И ЗначениеЗаполнено(СтруктураОтбора) Тогда
		
		Если СтруктураОтбора.Свойство("Организация") И ЗначениеЗаполнено(СтруктураОтбора.Организация) Тогда
			ОтборОрганизация = СтруктураОтбора.Организация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
			Параметры.Отбор.Удалить("Организация");
		КонецЕсли;
	Иначе
		Если ОтборОрганизация <> ОсновнаяОрганизация Тогда
			ОтборОрганизация = ОсновнаяОрганизация;
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		ИначеЕсли НЕ ОтборОрганизацияИспользование Тогда
			ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияИспользованиеПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 0.1, Истина);
	
	ПодключитьОбработчикОжидания("ПоказатьПредупреждениеПревышениеЛимитаТарифа", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборОрганизацияПриИзмененииСервер();
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьБаннер", 0.1, Истина);
	
	ПодключитьОбработчикОжидания("ПоказатьПредупреждениеПревышениеЛимитаТарифа", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ПомеченныеНаУдалениеКлиент.ПриИзмененииСписка(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОтборыСписков.СброситьИспользованиеПользовательскихОтборовВНастройке(Настройки);
	
	ПомеченныеНаУдалениеСервер.УдалитьОтборПометкаУдаления(Настройки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ РасчетЗарплатыДляНебольшихОрганизаций И НЕ Копирование Тогда
		Отказ = Истина;
		ОткрытьФорму("Документ.НачислениеЗарплаты.ФормаОбъекта", ПараметрыСозданияДокумента(), ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриПолученииДанныхНаСервере(Настройки, Строки);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	// КадровыйЭДО
	КадровыйЭДО.СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки);
	// Конец КадровыйЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ПодробнееОТарифах(Элемент)

	ОплатаСервисаКлиент.ОткрытьФормуОплатыСервиса();

КонецПроцедуры

// БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура Подключаемый_РазблокироватьОбъекты(Команда)
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьОбъектыСписка(ЭтотОбъект, Список, Элементы.Список.ВыделенныеСтроки);
КонецПроцедуры

// Конец БлокировкаИзмененияОбъектов

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНачислениеЗарплаты(Команда)
	
	ОткрытьФорму("Документ.НачислениеЗарплаты.ФормаОбъекта", ПараметрыСозданияДокумента(), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьБольничныйЛист(Команда)
	
	ОткрытьФорму("Документ.БольничныйЛист.ФормаОбъекта", ПараметрыСозданияДокумента(), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОтпуск(Команда)
	
	ОткрытьФорму("Документ.Отпуск.ФормаОбъекта", ПараметрыСозданияДокумента(), ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОтпускБезСохраненияОплаты(Команда)
	
	ОткрытьФорму("Документ.ОтпускБезСохраненияОплаты.ФормаОбъекта", ПараметрыСозданияДокумента(), ЭтотОбъект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтотОбъект,
		Команда
	);

КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБаннерНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер");
	
	ПерсонализированныеПредложенияСервисовКлиент.ЗакрытьБаннер(ЭтотОбъект, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийБаннерНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер");
	
	ПерсонализированныеПредложенияСервисовКлиент.УстановитьРежимОжиданияНаБаннере(ЭтотОбъект);
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьПредыдущийБаннер", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СледующийБаннерНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер");
	
	ПерсонализированныеПредложенияСервисовКлиент.УстановитьРежимОжиданияНаБаннере(ЭтотОбъект);
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область Баннер

&НаКлиенте
Процедура Подключаемый_УстановитьБаннер()
	
	УстановитьБаннер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьСледующийБаннер()
	
	// Поскольку обработчик может вызываться не только интерактивно пользователем,
	// но и автоматически по таймеру, меняем баннер при условии, что форма находится в фокусе.
	Если НЕ ВводДоступен() Тогда
		ПодключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер",
			ПерсонализированныеПредложенияСервисовКлиент.ИнтервалПереключенияБаннеров(), Истина);
		Возврат;
	КонецЕсли;
	
	УстановитьБаннер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УстановитьПредыдущийБаннер()
	
	УстановитьБаннер(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьБаннер(ПоказатьПредыдущий = Ложь)
	
	ДлительнаяОперация = ПолучитьБаннерНаСервере(ПоказатьПредыдущий);
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус <> "Ошибка" Тогда
		
		НастройкиОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		НастройкиОжидания.ВыводитьОкноОжидания = Ложь;
		
		Обработчик = Новый ОписаниеОповещения("ПослеПолученияБаннераВФоне", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Обработчик, НастройкиОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияБаннераВФоне(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		УстановитьБаннерНаФорме(ДлительнаяОперация.АдресРезультата);
		ПодключитьОбработчикОжидания("Подключаемый_УстановитьСледующийБаннер",
			ПерсонализированныеПредложенияСервисовКлиент.ИнтервалПереключенияБаннеров(), Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьБаннерНаСервере(ПоказатьПредыдущий)
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение баннера в фоне'");
	НастройкиЗапуска.ЗапуститьВФоне = Истина;
	НастройкиЗапуска.ОжидатьЗавершение = 0;
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("Организация", ?(ОтборОрганизацияИспользование, ОтборОрганизация, Неопределено));
	СтруктураПараметров.Вставить("Размещение", ПерсонализированныеПредложенияСервисов.ИмяРазмещенияНачислениеЗарплаты());
	СтруктураПараметров.Вставить("ПоказатьПредыдущий", ПоказатьПредыдущий);
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ПерсонализированныеПредложенияСервисов.ПолучитьБаннер",
		СтруктураПараметров,
		НастройкиЗапуска);
	
КонецФункции

&НаСервере
Процедура УстановитьБаннерНаФорме(АдресРезультата)
	
	ПерсонализированныеПредложенияСервисов.УстановитьБаннерНаФорме(ЭтотОбъект, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтборОрганизацияПриИзмененииСервер()
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыПриСозданииНаСервере(Параметры)
	
	ВходящийОтборПоОрганизации = Ложь;
	СтруктураОтбора = Неопределено;
	Если Параметры.Свойство("Отбор", СтруктураОтбора) И ТипЗнч(СтруктураОтбора) = Тип("Структура") Тогда
		ВходящийОтборПоОрганизации = СтруктураОтбора.Свойство("Организация", ОтборОрганизация);
		ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
		ЗаполнитьОтборПриОткрытииИзПараметров(Параметры.Отбор);
	КонецЕсли;
	
	ОсновнаяОрганизация = Справочники.Организации.ОрганизацияПоУмолчанию();
	
	Если НЕ ВходящийОтборПоОрганизации И ОтборОрганизация <> ОсновнаяОрганизация Тогда
		ОтборОрганизация                 = ОсновнаяОрганизация;
		ОтборОрганизацияИспользование    = ЗначениеЗаполнено(ОтборОрганизация);
	КонецЕсли;
	
	УстановитьВосстановленныеОтборы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтборПриОткрытииИзПараметров(Отбор)
	
	// Нужно переложить отборы из параметров в отдельную структуру,
	// которую потом будем использовать в ПриЗагрузкеДанныхИзНастроекНаСервере
	// Так как мы устанавливаем отбор самостоятельно, то нужно очистить те поля
	// структуры "Параметры.Отбор", для которых установлен отбор из кода.
	// Если не очистить поля - то будет вызвана ошибка пересечения отборов.
	
	ОтборыПриОткрытии = Новый Структура;
	
	Если Отбор.Свойство("Организация")
		И ЗначениеЗаполнено(Отбор.Организация) Тогда
		
		ОтборыПриОткрытии.Вставить("Организация", Отбор.Организация);
		Отбор.Удалить("Организация");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВосстановленныеОтборы()
	
	ОтборыСписковКлиентСервер.УстановитьБыстрыйОтбор(ЭтотОбъект, "Организация");
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыСозданияДокумента()
	
	ЗначенияЗаполнения = Новый Структура;
	
	Для каждого НастройкаКомпоновщика Из Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(НастройкаКомпоновщика) = Тип("ОтборКомпоновкиДанных") Тогда
			Для каждого ЭлементОтбора Из НастройкаКомпоновщика.Элементы Цикл
				Если ЭлементОтбора.Использование И ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
					ЗначенияЗаполнения.Вставить(ЭлементОтбора.ЛевоеЗначение, ЭлементОтбора.ПравоеЗначение);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли; 
	КонецЦикла;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПараметрОтбораПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПараметрОтбораНаФормеСДинамическимСпискомПриИзменении(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

// СтандартныеПодсистемы.КонтрольВеденияУчета
&НаКлиенте
Процедура Подключаемый_Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) Экспорт
	КонтрольВеденияУчетаКлиентБЗК.ОткрытьОтчетПоПроблемамИзСписка(ЭтотОбъект, "Список", Поле, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура ПоказатьПредупреждениеПревышениеЛимитаТарифа()
	
	ТарификацияБПКлиент.ОтобразитьБаннерПревышенияЛимитаТарифаНаЧислоСотрудников(
		ЭтотОбъект, ОтборОрганизация, ОтборОрганизацияИспользование);
	
КонецПроцедуры

#КонецОбласти

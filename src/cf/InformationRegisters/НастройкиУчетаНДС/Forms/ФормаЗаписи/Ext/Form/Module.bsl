﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ПараметрыОткрытия", ПараметрыОткрытия);
	
	Если Параметры.Ключ.Пустой() Тогда
		ЕстьВводОстатковПоРУ = ПроверитьНаличиеДокументовВводаОстатковПоРУ();
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	ОрганизацияВелаРаздельныйУчет = ПроверитьЗначениеПредыдущихНастроекРУ(ЭтотОбъект.НастройкиУчетаНДС.Организация, ЭтотОбъект.НастройкиУчетаНДС.Период);
	ТаблицаКодовОпераций0.Загрузить(УчетНДС.КлассификаторКодовОперацийПоСтавке0(НастройкиУчетаНДС.Период));

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТипЗнч(ПараметрыОткрытия) = Тип("Структура") Тогда
		АктивныйЭлемент = Неопределено;
		ПараметрыОткрытия.Свойство("АктивныйЭлемент", АктивныйЭлемент);
		Если ТипЗнч(АктивныйЭлемент) = Тип("Строка") Тогда
			ЭтаФорма.ТекущийЭлемент = ЭтаФорма.Элементы.Найти(АктивныйЭлемент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ЕстьВводОстатковПоРУ = ПроверитьНаличиеДокументовВводаОстатковПоРУ();

	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ОрганизацияВелаРаздельныйУчет И ЭтотОбъект.НастройкиУчетаНДС.РаздельныйУчетНДСНаСчете19  Тогда
		Если ЭтотОбъект.НастройкиУчетаНДС.Период <> НачалоКвартала(ЭтотОбъект.НастройкиУчетаНДС.Период) Тогда
			ТекстСообщения = НСтр("ru = 'Раздельный учет НДС можно включить только с начала квартала'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"Период");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("АдресХранилищаПереключениеОтложенногоПроведения",
		НастройкиУчетаВызовСервера.ПодготовитьДанныеДляПереключенияОтложенногоПроведения(УникальныйИдентификатор, ТекущийОбъект.Организация));

	ПараметрыЗаписи.Вставить("ИспользуетсяРаздельныйУчетНДСПередЗаписью", 
		 РегистрыСведений.НастройкиУчетаНДС.ПолучитьИспользуетсяРаздельныйУчетНДС());

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ОрганизацияВелаРаздельныйУчет И ЭтотОбъект.НастройкиУчетаНДС.РаздельныйУчетНДСНаСчете19 Тогда
		РегистрыСведений.ВыполнениеРегламентныхОперацийНДС.ЗафиксироватьФактВыполненияРегламентнойОперации(ЭтотОбъект.НастройкиУчетаНДС.Период,
			ЭтотОбъект.НастройкиУчетаНДС.Организация,
			Неопределено,
			Перечисления.РегламентныеОперации.ФормированиеНачальныхОстатковДляВеденияРаздельногоУчетаНДС,
			Истина);
		Элементы.ГруппаОткрытияДокументовВводОстатков.Видимость = Истина;
	КонецЕсли;


	РезультатЗаданияПереключенияОтложенногоПроведения = НастройкиУчетаВызовСервера.ПроверитьОтложенноеПроведениеПослеИзмененияНастроек(
		УникальныйИдентификатор,
		ПараметрыЗаписи.АдресХранилищаПереключениеОтложенногоПроведения);
	ПараметрыЗаписи.Вставить("РезультатЗаданияПереключенияОтложенногоПроведения", РезультатЗаданияПереключенияОтложенногоПроведения);

	ПараметрыЗаписи.Вставить("ИспользуетсяРаздельныйУчетНДСПослеЗаписи", 
		РегистрыСведений.НастройкиУчетаНДС.ПолучитьИспользуетсяРаздельныйУчетНДС());

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Очистку регистра ПроверенныеДокументы должны сделать в любом случае. Она продолжится, даже если форма закроется.
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеЗаписиЗавершение", ЭтотОбъект, ПараметрыЗаписи);
	ПроведениеКлиент.НачатьОчисткуРегистраПроверенныхДокументов(
		ОповещениеОЗавершении, НастройкиУчетаНДС.Период, НастройкиУчетаНДС.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	ПараметрыОповещения = Новый Структура("Организация, Период", НастройкиУчетаНДС.Организация, НастройкиУчетаНДС.Период);
	Оповестить("Запись_НастройкиУчетаНДС", ПараметрыОповещения);

	НастройкиУчетаНДСФормыКлиент.ОбновитьИнтерфейсПослеЗаписиНастройкиУчетаНДС(ПараметрыЗаписи);

	// Открытие окна ожидания по отложенному проведению произойдет после завершения очистки ПроверенныеДокументы.
	ПроведениеКлиент.ОжидатьПереключенияОтложенногоПроведения(ПараметрыЗаписи.РезультатЗаданияПереключенияОтложенногоПроведения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НастройкиСистемыНалогообложения" Тогда
		
		ОрганизацияОповещения = Неопределено;
		Если Параметр.Свойство("Организация", ОрганизацияОповещения) И ОрганизацияОповещения = НастройкиУчетаНДС.Организация Тогда
			УправлениеФормой(ЭтотОбъект);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СообщениеОбОшибкеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СистемаНалогообложения" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		НастройкиУчетаКлиент.ОбработкаНавигационнойСсылкиСистемаНалогообложения(
			ЭтотОбъект, НастройкиУчетаНДС.Организация, НастройкиУчетаНДС.Период);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЕстьВводОстатковПоРУ = ПроверитьНаличиеДокументовВводаОстатковПоРУ();
	
	УправлениеФормой(ЭтотОбъект);
	
	ОрганизацияВелаРаздельныйУчет = ПроверитьЗначениеПредыдущихНастроекРУ(ЭтотОбъект.НастройкиУчетаНДС.Организация, ЭтотОбъект.НастройкиУчетаНДС.Период);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ЕстьВводОстатковПоРУ = ПроверитьНаличиеДокументовВводаОстатковПоРУ();
	НастройкиУчетаНДСФормыКлиент.ПериодПриИзменении(ЭтотОбъект, Элемент);
	УправлениеФормой(ЭтотОбъект);

	ОрганизацияВелаРаздельныйУчет = ПроверитьЗначениеПредыдущихНастроекРУ(ЭтотОбъект.НастройкиУчетаНДС.Организация, ЭтотОбъект.НастройкиУчетаНДС.Период); 
	КлассификаторКодовОперацийПоСтавке0();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("НачалоПериода", НачалоМесяца(НастройкиУчетаНДС.Период));
	ПараметрыВыбора.Вставить("КонецПериода",  КонецМесяца(НастройкиУчетаНДС.Период));
	ПараметрыВыбора.Вставить("ВидПериода",    ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПериодЗавершениеВыбора", ЭтотОбъект);
	
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодЗавершениеВыбора(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		
		Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			РезультатВыбора.НачалоПериода,
			РезультатВыбора.КонецПериода,
			Истина);
		
		Модифицированность = Истина;
		
		НастройкиУчетаНДС.Период = РезультатВыбора.НачалоПериода;
		
		ПериодПриИзменении(Элементы.Период);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	НачалоПериода = НачалоМесяца(НастройкиУчетаНДС.Период);
	КонецПериода  = КонецМесяца(НастройкиУчетаНДС.Период);
	
	ВыборПериодаКлиент.ПериодОбработкаВыбора(
		Элемент,
		ВыбранноеЗначение,
		СтандартнаяОбработка,
		ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц"),
		Период,
		НачалоПериода,
		КонецПериода);
	
	Модифицированность = Истина;
	
	НастройкиУчетаНДС.Период = НачалоПериода;
	
	ПериодПриИзменении(Элементы.Период);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	НачалоПериода = НачалоМесяца(НастройкиУчетаНДС.Период);
	КонецПериода  = КонецМесяца(НастройкиУчетаНДС.Период);
	
	ВыборПериодаКлиент.ПериодАвтоПодбор(
		Элемент,
		Текст,
		ДанныеВыбора,
		Ожидание,
		СтандартнаяОбработка,
		ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц"),
		Период,
		НачалоПериода,
		КонецПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура СложныйУчетНДСПриИзменении(Элемент)
	
	НастройкиУчетаНДСФормыКлиент.СложныйУчетНДСПриИзменении(ЭтотОбъект, Элемент);
	НастройкиУчетаНДСФормыКлиентСервер.УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УпрощенныйУчетНДСПриИзменении(Элемент)
	
	НастройкиУчетаНДСФормыКлиент.УпрощенныйУчетНДСПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьДолюВычетаПриИзменении(Элемент)
	
	НастройкиУчетаНДСФормыКлиент.КонтролироватьДолюВычетаПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Период = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		НачалоМесяца(НастройкиУчетаНДС.Период),
		КонецМесяца(НастройкиУчетаНДС.Период),
		Истина);
	
	НастройкиУчета.ПодготовитьФормуНаСервере(ЭтотОбъект, НастройкиУчетаНДС);
	НастройкиУчетаНДСФормы.ПодготовитьФормуНаСервере(ЭтотОбъект);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Запись   = Форма.НастройкиУчетаНДС;
	
	Элементы.ПроверьтеНастройкиСистемыНалогообложения.Видимость = Не ПлательщикНДС(Запись.Организация, Запись.Период);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПлательщикНДС(Знач Организация, Знач Период)
	
	Возврат УчетнаяПолитика.ПлательщикНДС(Организация, Период);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьВводОстатков(Команда)
	
	ПараметрыДляОткрытияФормы = Новый Структура("Организация, ДоступенОтборПоОрганизации, ВключатьОбособленныеПодразделения", 
		ЭтотОбъект.НастройкиУчетаНДС.Организация, Истина, Ложь);
	ОткрытьФорму("ОбщаяФорма.ВводНачальныхОстатковДляВеденияРаздельногоУчетаНДС", ПараметрыДляОткрытияФормы);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЗначениеПредыдущихНастроекРУ(Организация, Дата)
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
			"ВЫБРАТЬ
			|	ВЫБОР
			|		КОГДА НастройкиУчетаНДССрезПоследних.РаздельныйУчетНДСНаСчете19
			|			ТОГДА НастройкиУчетаНДССрезПоследних.РаздельныйУчетНДСНаСчете19
			|		ИНАЧЕ НастройкиУчетаНДССрезПоследних.РаздельныйУчетНДСДо2014Года
			|	КОНЕЦ КАК РаздельныйУчетНДСНаСчете19
			|ИЗ
			|	РегистрСведений.НастройкиУчетаНДС.СрезПоследних(&Дата, Организация = &Организация) КАК НастройкиУчетаНДССрезПоследних" ;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Дата", 		 Дата);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество() > 0 Тогда
		Возврат Результат[0].РаздельныйУчетНДСНаСчете19;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПроверитьНаличиеДокументовВводаОстатковПоРУ()
	
	Возврат РегистрыСведений.ВыполнениеРегламентныхОперацийНДС.СуществуютДокументыВводаОстатковПоРУ(
				ЭтотОбъект.НастройкиУчетаНДС.Организация, НастройкиУчетаНДС.Период);
	
КонецФункции

&НаКлиенте
Процедура КодОперации0НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		СтандартнаяОбработка = Ложь;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Выбор кода операции НДС 0%");
	ПараметрыФормы.Вставить("ТаблицаЗначений", ТаблицаКодовОпераций0);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", НастройкиУчетаНДС.КодОперации0));
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ВвестиКодОперации0Завершение", ЭтотОбъект, Новый Структура);
		
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы",
	ПараметрыФормы, ЭтаФорма,,,, ОписаниеОповещения,);

КонецПроцедуры

&НаКлиенте
Процедура ВвестиКодОперации0Завершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиУчетаНДС.КодОперации0 = РезультатВыбора.Код;
	
КонецПроцедуры

&НаСервере
Процедура КлассификаторКодовОперацийПоСтавке0()
	
	ТаблицаКодовОпераций0.Загрузить(УчетНДС.КлассификаторКодовОперацийПоСтавке0(НастройкиУчетаНДС.Период));
	
КонецПроцедуры

#КонецОбласти
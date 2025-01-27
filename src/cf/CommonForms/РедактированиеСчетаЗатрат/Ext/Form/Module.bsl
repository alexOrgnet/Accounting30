﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// На форме отображаются только те реквизиты, значения которых переданы в параметрах.
	// Часть параметров используются во всех сценариях, и поэтому они есть всегда (см. закладку Параметры формы).
	// Код ниже рассчитывает на то, что параметры формы, реквизиты формы и соответствующие им элементы формы называются одинаково.
	
	Для каждого РеквизитФормы Из ПолучитьРеквизиты() Цикл
		ИмяРеквизита = РеквизитФормы.Имя;
		Если Параметры.Свойство(ИмяРеквизита) Тогда
			
			ЭтотОбъект[ИмяРеквизита] = Параметры[ИмяРеквизита]; 
			
			Если Элементы.Найти(ИмяРеквизита) = Неопределено Тогда
				Продолжить;
			КонецЕсли;	
			
			Элементы[ИмяРеквизита].Видимость = Истина;
			
		КонецЕсли;	
	КонецЦикла; 
	
	// В разных сценариях количество отображаемых полей различно.
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
		
	НаименованиеОбъекта = "";
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		НаименованиеОбъекта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "Наименование");
	ИначеЕсли КлючНазначенияИспользования = "КомандировочныеРасходы" Тогда
		НаименованиеОбъекта = НСтр("ru = 'Суточные'");
	КонецЕсли;
	
	Если ПустаяСтрока(НаименованиеОбъекта) Тогда
		Заголовок = ?(КлючНазначенияИспользования = "РасходМатериалов",
			НСтр("ru = 'Счета затрат'"),
			НСтр("ru = 'Счета учета'"));
	Иначе
		ШаблонЗаголовка = ?(КлючНазначенияИспользования = "РасходМатериалов",
			НСтр("ru = 'Счета затрат:  %1'"),
			НСтр("ru = 'Счета учета: %1'"));
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонЗаголовка, НаименованиеОбъекта);
	КонецЕсли;
		
	УстановитьФункциональныеОпцииФормы();
	
	// Счет учета НДС виден, если его значение передано в параметрах формы и если он имеет смысл
	Элементы.СчетУчетаНДС.Видимость = Элементы.СчетУчетаНДС.Видимость 
	    И (РаздельныйУчетНДСНаСчете19 ИЛИ НЕ НДСВключенВСтоимость ИЛИ УчетАгентскогоНДС);

	СтатьяЗатрат = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.СтатьиЗатрат.ПрочиеЗатраты");
	
	Если КлючНазначенияИспользования = "КомандировочныеРасходы" Тогда
		СтатьяЗатрат = УчетКомандировок.СтатьяЗатратКомандировочныеРасходы();
	КонецЕсли;
	
	СчетЗатратОбработатьИзменение();
	СчетЗатратНУОбработатьИзменение();
	
	ФормаОткрытаИзШапки = Истина;
	Параметры.Свойство("ФормаОткрытаИзШапки", ФормаОткрытаИзШапки);
	
	Элементы.ГруппаРасположениеСчетовУчета.Видимость = Ложь;
	Если (КлючНазначенияИспользования = КлючНазначенияИспользованияРасходМатериалов() 
			Или КлючНазначенияИспользования = КлючНазначенияИспользованияВыплатыСамозанятым()) И ФормаОткрытаИзШапки Тогда
		Элементы.ГруппаРасположениеСчетовУчета.Видимость = Истина;
		УстановитьПереключательРасположенияСчетовЗатрат(ЭтотОбъект);
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"БП.ОбщаяФорма.РедактированиеСчетаЗатрат",
		"ОбщаяФорма",
		НСтр("ru='Новости: Счета учета затрат'"),
		ИдентификаторыСобытийПриОткрытии
	);
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		Отказ = Истина;
		
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемФормыЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
	Если ПеренестиВДокумент Тогда
		Отказ = Отказ Или Не ПроверитьЗаполнениеНаКлиенте();
	КонецЕсли;
	
	Если Отказ Тогда
		ПеренестиВДокумент = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ПеренестиВДокумент Тогда
		СтруктураРезультат = Новый Структура();
		СтруктураРезультат.Вставить("СчетЗатрат",     СчетЗатрат);
		СтруктураРезультат.Вставить("ПодразделениеЗатрат", ПодразделениеЗатрат);
		СтруктураРезультат.Вставить("Субконто1",      Субконто1);
		СтруктураРезультат.Вставить("Субконто2",      Субконто2);
		СтруктураРезультат.Вставить("Субконто3",      Субконто3);
		
		СтруктураРезультат.Вставить("СчетУчетаНДС",   СчетУчетаНДС);
		СтруктураРезультат.Вставить("СпособУчетаНДС", СпособУчетаНДС);
		
		СтруктураРезультат.Вставить("СчетЗатратНУ",   СчетЗатратНУ);
		СтруктураРезультат.Вставить("СубконтоНУ1",    СубконтоНУ1);
		СтруктураРезультат.Вставить("СубконтоНУ2",    СубконтоНУ2);
		СтруктураРезультат.Вставить("СубконтоНУ3",    СубконтоНУ3);
		
		СтруктураРезультат.Вставить("ОтражениеВУСН",  ОтражениеВУСН);
		
		СтруктураРезультат.Вставить("СчетаУчетаЗатратВТаблице", СчетаУчетаЗатратВТаблице);
		СтруктураРезультат.Вставить("СтатьиЗатратВТаблицеПоУмолчанию", СтатьиЗатратВТаблицеПоУмолчанию);
		СтруктураРезультат.Вставить("ФормаОткрытаИзШапки", ФормаОткрытаИзШапки);
		 
		ЗаполнитьЗначенияСвойств(СтруктураРезультат, ЭтотОбъект);
		ОповеститьОВыборе(СтруктураРезультат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ФормаРедактированияСтроки_Закрыть" И Источник = ВладелецФормы Тогда
		// Сообщение от основной формы документа при нажатии там Esc.
		// Сбрасываем флаг модифицированности и закрываем форму редактирования строки без вопросов.
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СчетЗатратПриИзменении(Элемент)
	
	СчетЗатратПриИзмененииСервер();
		
КонецПроцедуры

&НаКлиенте
Процедура Субконто1ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто2ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(2);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто3ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(3);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратНУПриИзменении(Элемент)
	
	СчетЗатратНУПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконтоНУ(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ1ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоНУ(1);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконтоНУ(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ2ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоНУ(2);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконтоНУ(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоНУ3ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоНУ(3);
	
КонецПроцедуры

&НаКлиенте
Процедура РасположениеСчетовЗатратПриИзменении(Элемент)
	
	СчетаУчетаЗатратВТаблице = (РасположениеСчетовЗатрат = 1);
	Элементы.ГруппаСчетаУчета.Видимость = Не СчетаУчетаЗатратВТаблице;
	
	УстановитьВидимостьНастроекЗаполненияСтатейЗатрат(ЭтотОбъект);
	
	Если Элементы.ГруппаСчетаУчета.Видимость Тогда
		ПоляФормы = Новый Структура;
		ПоляФормы.Вставить("Субконто1", "Субконто1");
		ПоляФормы.Вставить("Субконто2", "Субконто2");
		ПоляФормы.Вставить("Субконто3", "Субконто3");
		
		ПараметрыОтображения = БухгалтерскийУчетКлиентСервер.НовыйПараметрыОтображенияАналитикиСчета();
		
		ЗаполнитьЗначенияСвойств(ПараметрыОтображения, ЭтотОбъект);
		
		ПараметрыОтображения.ЭтоТаблица       = Ложь;
		ПараметрыОтображения.СкрыватьСубконто = Истина;
		
		БухгалтерскийУчетКлиентСервер.ПриВыбореСчета(СчетЗатрат, ЭтотОбъект, ПоляФормы, ПараметрыОтображения);
	КонецЕсли;
	
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

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
		ЭтотОбъект,
		Команда);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СчетЗатратПриИзмененииСервер()
	
	СчетЗатратОбработатьИзменение();
	
	Если Элементы.СчетЗатратНУ.Видимость Тогда
		СчетЗатратНУ = СчетЗатрат;
		СчетЗатратНУОбработатьИзменение();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СчетЗатратНУПриИзмененииСервер()
	
	СчетЗатратНУОбработатьИзменение();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// СчетУчетаНДС

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СчетУчетаНДС");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"СуммаНДС", ВидСравненияКомпоновкиДанных.Равно, 0);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	// СпособУчетаНДС

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "СпособУчетаНДС");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"СуммаНДС", ВидСравненияКомпоновкиДанных.Равно, 0);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрОрганизацияФункциональныхОпцийФормы(
		ЭтотОбъект, Организация, ДатаДокумента);
	
	ПлательщикНалогаНаПрибыль        = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, ДатаДокумента);
	ПрименяетсяУСНДоходыМинусРасходы = УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Организация, ДатаДокумента);
	ПрименяетсяАУСН                  = УчетнаяПолитика.ПрименяетсяАУСН(Организация, ДатаДокумента);
	РаздельныйУчетНДСНаСчете19       = УчетнаяПолитика.РаздельныйУчетНДСНаСчете19(Организация, ДатаДокумента);
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеНаКлиенте()
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(СчетЗатрат) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Счет затрат'"));
		Поле = "СчетЗатрат";
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
	КонецЕсли;
	
	// Для некоторых элементов формы видимость определяется параметрами открытия формы (см. ПриСозданииНаСервере()).
	// Если элемент скрыт, то это значит, что в вызвавшей форме соответствующий реквизит не требуется.
	
	Если Элементы.СчетУчетаНДС.Видимость Тогда
		Если СуммаНДС = 0  Тогда
			// Счет учета НДС необязательный
		Иначе
			Если НЕ ЗначениеЗаполнено(СчетУчетаНДС) Тогда
				ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Счет учета НДС'"));
				Поле = "СчетУчетаНДС";
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если (ПрименяетсяУСНДоходыМинусРасходы Или ПрименяетсяАУСН)
		И Элементы.ОтражениеВУСН.Видимость Тогда
		
		Если НЕ ЗначениеЗаполнено(ОтражениеВУСН) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Расходы (НУ)'"));
			Поле = "ОтражениеВУСН";
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если РаздельныйУчетНДСНаСчете19 И Элементы.СпособУчетаНДС.Видимость Тогда
		
		Если НЕ ЗначениеЗаполнено(СпособУчетаНДС) Тогда
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Поле", "Заполнение", НСтр("ru = 'Способ учета НДС'"));
			Поле = "СпособУчетаНДС";
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , Поле, "", Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаСервере
Функция ПараметрыУстановкиСвойствСубконто()
	
	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"Субконто", "ПодразделениеЗатрат", "Субконто", "ПодразделениеЗатрат", "СчетЗатрат");
	
	Результат.ПоляОбъекта.Вставить("ПодразделениеДоступность", "ПодразделениеЗатратДоступность");
	Результат.ПоляОбъекта.Вставить("УчетПоПодразделениям",     "ПодразделениеЗатратНУДоступность");
	
	Результат.ЗначенияПоУмолчанию.Вставить(
		ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат"),
		СтатьяЗатрат);
	Результат.ЗначенияПоУмолчанию.Вставить(
		ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы"),
		ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ПрочиеДоходыИРасходы.ПрочиеВнереализационныеДоходыРасходы"));
	
	Результат.ДопРеквизиты.Вставить("Организация", Организация);
	
	Если ЗначениеЗаполнено(СчетЗатрат) И ИспользоватьНастройкиУчетнойПолитики Тогда
		СвойстваСчета = БухгалтерскийУчет.СвойстваИАналитикаСчета(
			СчетЗатрат,
			Организация,
			ДатаДокумента);
		Результат.ДанныеСчета = СвойстваСчета.ДанныеСчета;
		Результат.ОтображаемаяАналитика = СвойстваСчета.ОтображаемаяАналитика;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПараметрыУстановкиСвойствСубконтоНУ()
	
	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"СубконтоНУ", "ПодразделениеЗатрат", "СубконтоНУ", "ПодразделениеЗатрат", "СчетЗатратНУ");
	
	Результат.ПоляОбъекта.Вставить("ПодразделениеДоступность", "ПодразделениеЗатратНУДоступность");
	Результат.ПоляОбъекта.Вставить("УчетПоПодразделениям",     "ПодразделениеЗатратДоступность");
		
	Результат.ЗначенияПоУмолчанию.Вставить(
		ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат"),
		СтатьяЗатрат);
		
	Результат.ЗначенияПоУмолчанию.Вставить(
		ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы"),
		ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ПрочиеДоходыИРасходы.ПрочиеВнереализационныеДоходыРасходы"));
	
	Результат.ДопРеквизиты.Вставить("Организация", Организация);
	
	Если ЗначениеЗаполнено(СчетЗатратНУ) И ИспользоватьНастройкиУчетнойПолитики Тогда
		СвойстваСчета = БухгалтерскийУчет.СвойстваИАналитикаСчета(
			СчетЗатрат,
			Организация,
			ДатаДокумента);
		Результат.ДанныеСчета = СвойстваСчета.ДанныеСчета;
		Результат.ОтображаемаяАналитика = СвойстваСчета.ОтображаемаяАналитика;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СчетЗатратОбработатьИзменение()
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, ЭтотОбъект, ПараметрыУстановкиСвойствСубконто());
	
КонецПроцедуры

&НаСервере
Процедура СчетЗатратНУОбработатьИзменение()
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, ЭтотОбъект, ПараметрыУстановкиСвойствСубконтоНУ());

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСубконто(НомерСубконто)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСубконто(
		ЭтотОбъект, ЭтотОбъект, НомерСубконто, ПараметрыУстановкиСвойствСубконто());
	
	Если ПлательщикНалогаНаПрибыль Тогда
		
		ПриИзмененииСубконтоНУ(НомерСубконто);
		
		Если ЗначениеЗаполнено(СчетЗатрат)
			И ЗначениеЗаполнено(СчетЗатратНУ) Тогда
			
			ДанныеСчетаБУ = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетЗатрат);
			ДанныеСчетаНУ = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетЗатратНУ);
			
			Для ИндексБУ = 1 По 3 Цикл
				Для ИндексНУ = 1 По 3 Цикл
					Если ДанныеСчетаБУ["ВидСубконто" + ИндексБУ + "ТипЗначения"] = ДанныеСчетаНУ["ВидСубконто" + ИндексНУ + "ТипЗначения"] Тогда
						ЭтотОбъект["СубконтоНУ" + ИндексНУ] = ЭтотОбъект["Субконто" + ИндексБУ];
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
			
		КонецЕсли;
	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		ЭтотОбъект, ПараметрыУстановкиСвойствСубконто());
	
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДанныеОбъекта);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСубконтоНУ(НомерСубконто)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСубконто(
		ЭтотОбъект, ЭтотОбъект, НомерСубконто, ПараметрыУстановкиСвойствСубконтоНУ());
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконтоНУ(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		ЭтотОбъект, ПараметрыУстановкиСвойствСубконтоНУ());
	
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемФормыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Модифицированность = Ложь;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПереключательРасположенияСчетовЗатрат(Форма)
	
	Элементы = Форма.Элементы;
	Форма.РасположениеСчетовЗатрат = ?(Форма.СчетаУчетаЗатратВТаблице, 1, 0);
	Элементы.ГруппаСчетаУчета.Видимость = Не Форма.СчетаУчетаЗатратВТаблице;
	
	УстановитьВидимостьНастроекЗаполненияСтатейЗатрат(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьНастроекЗаполненияСтатейЗатрат(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ГруппаНастройкиЗаполненияСтатейЗатрат.Видимость = Форма.СчетаУчетаЗатратВТаблице
		И Форма.КлючНазначенияИспользования = КлючНазначенияИспользованияРасходМатериалов();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция КлючНазначенияИспользованияРасходМатериалов()
	
	Возврат "РасходМатериалов";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция КлючНазначенияИспользованияВыплатыСамозанятым()
	
	Возврат "ВыплатыСамозанятым";
	
КонецФункции

#КонецОбласти

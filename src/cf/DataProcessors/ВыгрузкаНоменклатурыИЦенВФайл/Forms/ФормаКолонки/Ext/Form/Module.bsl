﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СхемаКомпоновкиДанных = Параметры.СхемаКомпоновкиДанных;
	ИсключенныеПоля = Параметры.ИсключенныеПоля;
	ДопПоля = ПолучитьИзВременногоХранилища(Параметры.АдресХранилищаДопНастроек);
	
	ТекстПолеНаименование = НСтр("ru = 'Наименование'");
	
	НоваяСтрока = ДополнительныеПоля.Добавить();
	НоваяСтрока.ОбязательноеПоле = Истина;
	НоваяСтрока.Поле = "Номенклатура";
	НоваяСтрока.Представление = ТекстПолеНаименование;
	
	Для Каждого Поле из ДопПоля Цикл
		НоваяСтрока = ДополнительныеПоля.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Поле);
	КонецЦикла
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеПоля

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Выбор");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , ИсключенныеПоля);
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Неопределено);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", ЭтотОбъект);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ДополнительныеПоляПередНачаломДобавленияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы,,,,,ОповещениеОЗакрытии);
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СхемаКомпоновкиДанных", СхемаКомпоновкиДанных);
	ПараметрыФормы.Вставить("Режим"                , "Выбор");
	ПараметрыФормы.Вставить("ИсключенныеПоля"      , ИсключенныеПоля);
	ПараметрыФормы.Вставить("ТекущаяСтрока"        , Элемент.ТекущиеДанные.Поле);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Элемент", Элемент);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ДополнительныеПоляПередНачаломИзмененияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораДоступногоПоля", ПараметрыФормы,,,,,ОповещениеОЗакрытии);
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		НоваяСтрока = ДополнительныеПоля.Добавить();
		НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
		НоваяСтрока.Представление = Сред(ПараметрыВыбранногоПоля.Заголовок, Найти(ПараметрыВыбранногоПоля.Заголовок,".")+1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	ПараметрыВыбранногоПоля = РезультатЗакрытия;
	
	Если ТипЗнч(ПараметрыВыбранногоПоля) = Тип("Структура") Тогда
		НоваяСтрока = Элемент.ТекущиеДанные;
		НоваяСтрока.Поле          = ПараметрыВыбранногоПоля.Поле;
		НоваяСтрока.Представление = Сред(ПараметрыВыбранногоПоля.Заголовок, Найти(ПараметрыВыбранногоПоля.Заголовок,".")+1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередУдалением(Элемент, Отказ)
	
	Если Элементы.ДополнительныеПоля.ТекущаяСтрока = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""%1"" должно выгружаться всегда'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ТекстПолеНаименование);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ДополнительныеПоля.Представление");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Элементы.ДополнительныеПоля.ТекущаяСтрока = 0 И ДополнительныеПоля.Количество()> 1 Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось изменить порядок строк. Поле ""%1"" должно выгружаться первым'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, ТекстПолеНаименование);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ДополнительныеПоля.Представление");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьстрокуВниз(Команда)
	ТекущаяСтрока = Элементы.ДополнительныеПоля.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		Индекс = ДополнительныеПоля.Индекс(ДополнительныеПоля.НайтиПОИдентификатору(ТекущаяСтрока));
		Если ТекущаяСтрока = 0 или Индекс = ДополнительныеПоля.Количество()-1 Тогда
			
			ТекстСообщения = НСтр("ru = 'Не удалось изменить порядок строк. Поле ""%1"" должно выгружаться первым'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, ТекстПолеНаименование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ДополнительныеПоля.ДополнительныеПоляПредставление");
			
		Иначе
			
			ДополнительныеПоля.Сдвинуть(Индекс, 1);
			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьСтрокуВверх(Команда)
	ТекущаяСтрока = Элементы.ДополнительныеПоля.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ЗаголовокПоля = Элементы.ДополнительныеПоля.ТекущиеДанные.Представление;
		Индекс = ДополнительныеПоля.Индекс(ДополнительныеПоля.НайтиПОИдентификатору(ТекущаяСтрока));
		Если ТекущаяСтрока = 0 ИЛИ Индекс = 1 Тогда
			ТекстСообщения = НСтр("ru = 'Не удалось изменить порядок строк. Поле ""Наименование"" должно выгружаться первым'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ДополнительныеПоля.ДополнительныеПоляПредставление");
		Иначе
			ДополнительныеПоля.Сдвинуть(Индекс, -1);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура ЗакрытьКнопка(Команда)
	
	АдресНастроек = АдресНастроекВоВременномХранилище();
	Закрыть(АдресНастроек);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АдресНастроекВоВременномХранилище()
	
	Отбор = Новый Структура("ОбязательноеПоле", Ложь);
	
	Возврат ПоместитьВоВременноеХранилище(ДополнительныеПоля.Выгрузить(Отбор), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти






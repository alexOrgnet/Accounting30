﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции




&НаКлиенте
Процедура ТитулГрузоотправителяВодителиПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ТекущиеДанные.ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеТитулГрузоотправителяВодительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбменСГИСЭПДКлиент.ХранимыеДанныеНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка, Элементы.ТитулГрузоотправителяВодители.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеТитулГрузоотправителяВодительПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТитулГрузоотправителяВодители.ТекущиеДанные;
	 
	ОбменСГИСЭПДКлиент.ХранимыеДанныеПриИзменении(ЭтотОбъект, 
					ТекущиеДанные.ХранимыеДанныеТитулГрузоотправителяВодитель, 
					Элемент, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ХранимыеДанныеВодительОткрытие(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТитулГрузоотправителяВодители.ТекущиеДанные;
	
	ОбменСГИСЭПДКлиент.ХранимыеДанныеОткрытие(ЭтотОбъект, ТекущиеДанные.ХранимыеДанныеВодитель, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры


&НаКлиенте
Процедура ХранимыеДанныеТитулГрузоотправителяВодительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ОбменСГИСЭПДКлиент.ХранимыеДанныеАвтоПодбор(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТитулГрузоотправителяСведенияОПутевыхЛистахНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Элемент.Имя, Элементы.ТитулГрузоотправителяВодители.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулГрузоотправителяВодителиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Поле.Имя = "ЗаполнитьТитулГрузоотправителяСведенияОПутевыхЛистах"
		Или Поле.Имя = "ХранимыеДанныеВодитель" Тогда
		ОбменСГИСЭПДКлиент.ВывестиФормуВводаДанных(ЭтотОбъект, Поле.Имя, Элемент.ТекущиеДанные, ЭтотОбъект.ЗапретитьИзменение = Ложь);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулГрузоотправителяВодителиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);

КонецПроцедуры



&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтметитьОбязательныеНеЗаполненныеЭлементыФормы" Тогда
		Если УникальныйИдентификатор <> Параметр Тогда
			Возврат;
		КонецЕсли;
		ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(Параметр);
	ИначеЕсли ИмяСобытия = "ИзменитьОформлениеКнопокФормы" Тогда
		Если УникальныйИдентификатор <> Параметр.УникальныйИдентификаторОбновляемойФормы Тогда
			Возврат;
		КонецЕсли;
		ИзменитьОформлениеКнопок(Параметр);	 
	ИначеЕсли СтрНачинаетсяС(ИмяСобытия, "Запись_") И Источник <> Неопределено Тогда
		Если ТипЗнч(Источник) = Тип("СправочникСсылка.ХранимыеДанныеЭПД") Тогда
			Для Каждого СтрокаВодитель Из ТитулГрузоотправителяВодители Цикл
				Если Источник = СтрокаВодитель.ХранимыеДанныеВодитель Тогда
					ВходящийКонтекст = Новый Структура;
					ВходящийКонтекст.Вставить("ЗапретитьИзменение", Ложь);
					ВходящийКонтекст.Вставить("Форма", ЭтотОбъект);
					ВходящийКонтекст.Вставить("ГруппаДанных", "Водитель");
					ВходящийКонтекст.Вставить("ТекущиеДанные", СтрокаВодитель);
					ОбменСГИСЭПДКлиент.ОткрытиеФормыПоГиперссылке_Завершение(Источник, ВходящийКонтекст);	
				КонецЕсли;	
			КонецЦикла;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область ОбъектыОбязательныеДляЗаполнения

&НаКлиенте
Процедура ИзменитьОформлениеКнопок(Параметр) Экспорт

	Если Не ЭтотОбъект.НачальноеОформлениеВыполнено Тогда
		ЭтотОбъект.ТребуетсяДополнительноеОформлениеКнопок = Истина;
		Если ЭтотОбъект.СтруктураДополнительногоОформленияКнопок <> Неопределено Тогда
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = 
				Новый ФиксированнаяСтруктура("ИмяКнопки, ИдентификаторСтроки");
		Иначе
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = Параметр;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СтруктураСТекущимиДаннымиРеквизитов = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	СтруктураДанныхОбъекта = ОбменСГИСЭПДКлиентСервер.ПолучитьСериализуемыйОбъектСДаннымиДокумента(ЭтотОбъект);
	СтруктураСДаннымиФормыДляОформленияКнопок = 
		ОбменСГИСЭПДКлиентСервер.СтруктураСДаннымиФормыДляОформленияКнопок(ЭтотОбъект);
	
	Результат = ИзменитьОформлениеКнопокНаСервере(СтруктураСТекущимиДаннымиРеквизитов,
		Параметр.ИмяКнопки,
		Параметр.ИдентификаторСтроки,
		СтруктураДанныхОбъекта,
		СтруктураСДаннымиФормыДляОформленияКнопок);
		
	Если Результат.Успешно Тогда
		ЭтотОбъект.АдресДереваСоответствийИтаблицыКнопок = Результат.НовыйАдресВХранилище;	
		МассивОформления = Результат.МассивОформления;
		ОбменСГИСЭПДКлиентСервер.ОформлениеКнопокНаФорме(ЭтотОбъект,
			СтруктураСТекущимиДаннымиРеквизитов, МассивОформления);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменитьОформлениеКнопокНаСервере(Знач СтруктураСТекущимиДаннымиРеквизитов,
	ИмяКнопки = Неопределено,
	ИдентификаторСтроки = Неопределено,
	Знач СтруктураДанныхОбъекта,
	Знач СтруктураСДаннымиФормыДляОформленияКнопок)
	
	НовыйАдресВХранилище = ОбменСГИСЭПД.ЗапуститьИзменениеОформленияКнопок(СтруктураСДаннымиФормыДляОформленияКнопок,
		СтруктураСТекущимиДаннымиРеквизитов, ИмяКнопки, ИдентификаторСтроки, СтруктураДанныхОбъекта);

	Результат = ОбменСГИСЭПД.ОбработатьРезультатИзмененияОформленияКнопок(НовыйАдресВХранилище);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(Параметр)
	
	СтруктураСТекущимиДаннымиРеквизитов = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(СтруктураСТекущимиДаннымиРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(Знач СтруктураСТекущимиДанными)
	
	ОбменСГИСЭПД.ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(ЭтотОбъект, СтруктураСТекущимиДанными);
	
КонецПроцедуры

#КонецОбласти
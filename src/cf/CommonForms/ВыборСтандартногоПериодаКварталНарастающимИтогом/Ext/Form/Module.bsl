﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, 
		Параметры, 
		"НачалоПериода, КонецПериода, МинимальныйПериод, МаксимальныйПериод, НарастающимИтогом");
		
	ДатаНачалаГода = ?(ЗначениеЗаполнено(КонецПериода), НачалоГода(КонецПериода), НачалоГода(ТекущаяДатаСеанса()));
	
	Если НарастающимИтогом Тогда
		Элементы.ВыборКвартала.Видимость = Ложь;
		Элементы.ВыборКварталаНарастающимИтогом.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
	Если ДатаНачалаГода < НачалоГода(МинимальныйПериод) Тогда
		Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Неверные параметры выбора периода.'");
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьАктивныйПериод();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиНаГодНазад(Команда)
	
	ДатаНачалаГода = НачалоГода(ДатаНачалаГода - 1);
	
	УстановитьАктивныйПериод();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаГодВперед(Команда)
	
	ДатаНачалаГода = КонецГода(ДатаНачалаГода) + 1;
	
	УстановитьАктивныйПериод();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал1(Команда)
	
	ВыбратьКвартал(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал2(Команда)
	
	ВыбратьКвартал(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал3(Команда)
	
	ВыбратьКвартал(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКвартал4(Команда)
	
	ВыбратьКвартал(4);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПолугодие1(Команда)
	
	ВыбратьПолугодие(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать9Месяцев(Команда)

	НачалоПериода = ДатаНачалаГода;
	КонецПериода  = Дата(Год(ДатаНачалаГода), 9 , 30);
	ВыполнитьВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГод(Команда)

	НачалоПериода = ДатаНачалаГода;
	КонецПериода  = КонецГода(ДатаНачалаГода);
	ВыполнитьВыборПериода();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьАктивныйПериод()

	Если НачалоКвартала(НачалоПериода) = НачалоКвартала(КонецПериода) 
		И НЕ НарастающимИтогом Тогда
		НомерКвартала = Месяц(КонецКвартала(КонецПериода)) / 3;
		ТекущийЭлемент = Элементы["ВыбратьКвартал" + НомерКвартала];
	ИначеЕсли НачалоГода(НачалоПериода) = НачалоГода(КонецПериода) Тогда
		НомерМесяцаНачала = Месяц(НачалоПериода);
		НомерМесяцаКонца  = Месяц(КонецПериода);
		Если НомерМесяцаНачала <= 3 И НомерМесяцаКонца <= 6 Тогда
			ТекущийЭлемент = Элементы["ВыбратьПолугодие1"];
		ИначеЕсли НомерМесяцаНачала <= 3 И НомерМесяцаКонца <= 9 Тогда
			ТекущийЭлемент = Элементы["Выбрать9Месяцев"];
		Иначе
			ТекущийЭлемент = Элементы["ВыбратьГод"];
		КонецЕсли;
	Иначе
		ТекущийЭлемент = Элементы["ВыбратьГод"];
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	ОграничитьСнизу(Форма);
	ОграничитьСверху(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОграничитьСнизу(Форма)
	
	Если Не ЗначениеЗаполнено(Форма.МинимальныйПериод) Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	ПрошлыйГодДоступен = Форма.ДатаНачалаГода > Форма.МинимальныйПериод;
	
	Элементы.ПерейтиНаГодНазад.Видимость           = ПрошлыйГодДоступен;
	Элементы.ПерейтиНаГодНазадНедоступно.Видимость = Не ПрошлыйГодДоступен;
	
	МинимальныйМесяц  = Месяц(НачалоКвартала(Форма.МинимальныйПериод));
	
	Если Не ПрошлыйГодДоступен И МинимальныйМесяц <> 1 Тогда
		
		// Установим доступность выбора кварталов
		Элементы.ВыбратьКвартал1.Доступность = Ложь;
		Элементы.ВыбратьКвартал2.Доступность = МинимальныйМесяц < 7;
		Элементы.ВыбратьКвартал3.Доступность = МинимальныйМесяц < 10;
		
		Элементы.Квартал.Доступность           = Ложь;
		Элементы.ВыбратьПолугодие1.Доступность = МинимальныйМесяц < 7;
		Элементы.Выбрать9Месяцев.Доступность   = МинимальныйМесяц < 10;
		
	Иначе
		
		Элементы.ВыбратьКвартал1.Доступность = Истина;
		Элементы.ВыбратьКвартал2.Доступность = Истина;
		Элементы.ВыбратьКвартал3.Доступность = Истина;
		
		Элементы.Квартал.Доступность           = Истина;
		Элементы.ВыбратьПолугодие1.Доступность = Истина;
		Элементы.Выбрать9Месяцев.Доступность   = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОграничитьСверху(Форма)
	
	Если Не ЗначениеЗаполнено(Форма.МаксимальныйПериод) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаКонцаГода      = КонецГода(Форма.КонецПериода);
	МаксимальныйМесяц  = Месяц(Форма.МаксимальныйПериод);
	
	Элементы = Форма.Элементы;
	СледующийГодДоступен = ДатаКонцаГода > КонецДня(Форма.МаксимальныйПериод);
	Элементы.ПерейтиНаГодВперед.Видимость           = СледующийГодДоступен;
	Элементы.ПерейтиНаГодВпередНедоступно.Видимость = Не СледующийГодДоступен;
	
	Если Не СледующийГодДоступен И МаксимальныйМесяц <> 12 Тогда
		
		// Установим доступность выбора кварталов
		Элементы.ВыбратьКвартал1.Доступность = МаксимальныйМесяц >= 3;
		Элементы.ВыбратьКвартал2.Доступность = МаксимальныйМесяц >= 6;
		Элементы.ВыбратьКвартал3.Доступность = МаксимальныйМесяц >= 9;
		Элементы.ВыбратьКвартал4.Доступность = МаксимальныйМесяц >= 12;
		
		Элементы.Квартал.Доступность           = МаксимальныйМесяц >= 3;
		Элементы.ВыбратьПолугодие1.Доступность = МаксимальныйМесяц >= 6;
		Элементы.Выбрать9Месяцев.Доступность   = МаксимальныйМесяц >= 9;
		Элементы.ВыбратьГод.Доступность        = МаксимальныйМесяц >= 12;
		
	Иначе
		
		Элементы.ВыбратьКвартал1.Доступность = Истина;
		Элементы.ВыбратьКвартал2.Доступность = Истина;
		Элементы.ВыбратьКвартал3.Доступность = Истина;
		Элементы.ВыбратьКвартал4.Доступность = Истина;
		
		Элементы.Квартал.Доступность           = Истина;
		Элементы.ВыбратьПолугодие1.Доступность = Истина;
		Элементы.Выбрать9Месяцев.Доступность   = Истина;
		Элементы.ВыбратьГод.Доступность        = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыборПериода()

	РезультатВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоПериода, КонецДня(КонецПериода));
	ОповеститьОВыборе(РезультатВыбора);

КонецПроцедуры 

&НаКлиенте
Процедура ВыбратьКвартал(НомерКвартала)
	
	НачалоПериода = Дата(Год(ДатаНачалаГода), 1 + (НомерКвартала - 1) * 3, 1);
	
	КонецПериода  = КонецКвартала(НачалоПериода);
	
	ВыполнитьВыборПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПолугодие(НомерПолугодия)

	НачалоПериода = Дата(Год(ДатаНачалаГода), 1 + (НомерПолугодия - 1) * 6, 1);
	КонецПериода  = КонецМесяца(ДобавитьМесяц(НачалоПериода, 5));
	ВыполнитьВыборПериода();
	
КонецПроцедуры

#КонецОбласти

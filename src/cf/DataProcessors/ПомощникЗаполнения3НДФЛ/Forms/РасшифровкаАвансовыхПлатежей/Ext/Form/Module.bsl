﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Организация, НачалоПериода, КонецПериода, Заголовок");
	
	Налог = Обработки.ПомощникЗаполнения3НДФЛ.ПоддерживаемыеВидыНалогов(НачалоПериода);
	ПравилаУплатыАвансов = ВыполнениеЗадачБухгалтера.ПравилаУплатыАвансовПоНДФЛ();
	
	Список.Параметры.УстановитьЗначениеПараметра("ПравилаУплатыАвансов", ПравилаУплатыАвансов);
	Список.Параметры.УстановитьЗначениеПараметра("Организация",          Организация);
	Список.Параметры.УстановитьЗначениеПараметра("НачалоПериода",        НачалоПериода);
	Список.Параметры.УстановитьЗначениеПараметра("КонецПериода",         КонецДня(КонецПериода));
	Список.Параметры.УстановитьЗначениеПараметра("Налог",                Налог);
	
	ОбновитьИтоги();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПлатежныйДокумент_УплатаНалогов" Тогда
		
		Элементы.Список.Обновить();
		ОбновитьИтоги();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьОперацию(Элемент.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьИтоги()
	
	ИтогиДинамическогоСписка = ОбщегоНазначенияБП.ИтогиДинамическогоСписка(Список, "Сумма");
	ИтогиСумма = ИтогиДинамическогоСписка.Сумма;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОперацию(Операция)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Операция);
	ПараметрыФормы.Вставить("НалоговыйПериод", КонецПериода);
	
	ОткрытьФорму(ИмяФормыДокумента(Операция), ПараметрыФормы);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяФормыДокумента(Ссылка)
	
	Возврат СтрШаблон("Документ.%1.ФормаОбъекта", Ссылка.Метаданные().Имя);
	
КонецФункции

#КонецОбласти

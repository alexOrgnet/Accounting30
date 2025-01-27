﻿
#Область КомандыФормы

&НаКлиенте
Процедура ЛьготныеКредиты(Команда)
	
	ОткрытьФормуВОкнеФормы("Документ.ЗаявкиНаЛьготныйКредит.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура Сервис1СОткрытиеСчета(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Заявки 1С:Открытие счета'"));
	
	ОткрытьФормуВОкнеФормы("РегистрСведений.СостояниеЗаявокНаОткрытиеСчета.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Сервис1СКредит(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("СервисОбменаСБанками",
		ПредопределенноеЗначение("Перечисление.СервисыОбменаСБанками.ЗаявкиНаКредит"));
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Заявки 1С:Кредит'"));
	
	ОткрытьФормуВОкнеФормы("РегистрСведений.СостояниеЗаявокНаКредит.ФормаСписка", ПараметрыФормы, "Заявки1СКредит");
	
КонецПроцедуры

&НаКлиенте
Процедура Сервис1СЛизинг(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("СервисОбменаСБанками",
		ПредопределенноеЗначение("Перечисление.СервисыОбменаСБанками.ЗаявкиНаЛизинг"));
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Заявки 1С:Лизинг'"));
	
	ОткрытьФормуВОкнеФормы("РегистрСведений.СостояниеЗаявокНаКредит.ФормаСписка", ПараметрыФормы, "Заявки1СЛизинг");
	
КонецПроцедуры

&НаКлиенте
Процедура Сервис1СФинОтчетность(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Заголовок",  НСтр("ru = '1С:ФинОтчетность'"));
	
	ОткрытьФормуВОкнеФормы("РегистрСведений.ЖурналСтатусовФинОтчетностиВБанки.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуВОкнеФормы(ИмяФормы, ПараметрыФормы = Неопределено, Уникальность = "")
	
	КлючФормы = ИмяФормы + Уникальность;
	
	ОткрытьФорму(ИмяФормы, ПараметрыФормы, ЭтотОбъект, КлючФормы, Окно);
	
КонецПроцедуры

#КонецОбласти
﻿#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("ОтветственноеЛицо") тогда
		Если Параметры.Отбор.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Исполнитель тогда	
			ЭтаФорма.Заголовок = "История подписи: Ответственный за статистическую отчетность";
		иначе
			ЭтаФорма.Заголовок = "История подписи: "+Параметры.Отбор.ОтветственноеЛицо;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

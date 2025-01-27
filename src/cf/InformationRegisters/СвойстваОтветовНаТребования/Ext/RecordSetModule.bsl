﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		КалендарьБылНезаполнен = Ложь;
		
		// Дата Ответа Рассчитанная
		Если ЗначениеЗаполнено(Запись.ДатаПодтверждения) 
			И ЗначениеЗаполнено(Запись.ДнейДоОтвета) Тогда
			
			Результат = ТребованияФНС.ДатаПлюсДниПоКалендарю(Запись.ДатаПодтверждения, Запись.ДнейДоОтвета);
			Запись.ОтветитьДо = Результат.Дата;
			
			Если НЕ Результат.КалендарьЗаполнен Тогда
				КалендарьБылНезаполнен = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Запись.ПодтвердитьДо)
			И ЗначениеЗаполнено(Запись.ДатаОтправкиТребования) Тогда
			
			Результат = ТребованияФНС.ДатаПлюсДниПоКалендарю(Запись.ДатаОтправкиТребования, 6);
			Запись.ПодтвердитьДо = Результат.Дата;
			
			Если НЕ Результат.КалендарьЗаполнен Тогда
				КалендарьБылНезаполнен = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		Запись.КалендарьБылНезаполнен = КалендарьБылНезаполнен;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли



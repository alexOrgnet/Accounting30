﻿#Область ПрограммныйИнтерфейс

// Возвращает включенную функциональность, которая не может использоваться по ограничениям тарифа
//
// Возвращаемое значение:
//  Соответствие из КлючИЗначение, где
//   - Ключ - имя функциональной опции
//   - Значение (необязательно) - имя тарифной опции, требуемой для использования данной функциональности
//
Функция НедоступнаяФункциональность() Экспорт
	
	ОписаниеФункциональности = Обработки.ФункциональностьПрограммы.ОписаниеФункциональности();
	НедоступнаяФункциональность = Обработки.ФункциональностьПрограммы.ВключеннаяНедоступнаяФункциональность(
		ОписаниеФункциональности);
		
	Возврат НедоступнаяФункциональность;
	
КонецФункции

#КонецОбласти
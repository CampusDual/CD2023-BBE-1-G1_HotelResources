package com.ontimize.hr.model.core.service;

import com.ontimize.hr.api.core.service.IBookingService;
import com.ontimize.hr.api.core.service.exception.*;
import com.ontimize.hr.model.core.dao.BookingDAO;
import com.ontimize.hr.model.core.dao.RoomDAO;
import com.ontimize.jee.common.dto.EntityResult;
import com.ontimize.jee.server.dao.DefaultOntimizeDaoHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.BiPredicate;
import java.util.function.Predicate;

@Lazy
@Service("BookingService")
public class BookingService implements IBookingService {

    @Autowired
    private DefaultOntimizeDaoHelper daoHelper;
    @Autowired
    private BookingDAO bookingDAO;
    @Autowired
    private RoomService roomService;

    Predicate<Map<?, ?>> arrivalDateBeforeNow = bookingMap -> {
        LocalDate arrivalDate = (LocalDate) bookingMap.get(BookingDAO.ARRIVAL_DATE);
        return arrivalDate.isBefore(LocalDate.now());
    };

    Predicate<Map<?, ?>> departureDateBeforeArrivalDate = bookingMap -> {
        LocalDate departureDate = (LocalDate) bookingMap.get(BookingDAO.DEPARTURE_DATE);
        LocalDate arrivalDate = (LocalDate) bookingMap.get(BookingDAO.ARRIVAL_DATE);
        return departureDate.isBefore(arrivalDate);
    };

    BiPredicate<Map<?, ?>, EntityResult> datesOverlapForRoomExcludingThisBooking = (bookingMap, bookingsForThisRoomEntityResult) -> {
        Integer presentBookingId = (Integer) bookingMap.get(BookingDAO.ID);
        LocalDate departureDate = (LocalDate) bookingMap.get(BookingDAO.DEPARTURE_DATE);
        LocalDate arrivalDate = (LocalDate) bookingMap.get(BookingDAO.ARRIVAL_DATE);

        LocalDate departureDateToCheck;
        LocalDate arrivalDateToCheck;

        for (int i = 0; i < bookingsForThisRoomEntityResult.calculateRecordNumber(); i++) {
            Map<?, ?> bookingToCheck = bookingsForThisRoomEntityResult.getRecordValues(i);

            if (bookingToCheck.get(BookingDAO.ID) == presentBookingId) {
                continue;
            }

            departureDateToCheck = (LocalDate) bookingToCheck.get(BookingDAO.DEPARTURE_DATE);
            arrivalDateToCheck = (LocalDate) bookingToCheck.get(BookingDAO.ARRIVAL_DATE);

            if (
                    (arrivalDate.isAfter(arrivalDateToCheck) || arrivalDate.isEqual(arrivalDateToCheck)) &&
                            (departureDate.isBefore(departureDateToCheck) || departureDate.isEqual(departureDateToCheck))
            ) {
                return true;
            }
        }

        return false;
    };

    BiPredicate<Map<?, ?>, EntityResult> datesOverlapForRoom = (bookingMap, bookingsForThisRoomEntityResult) -> {
        LocalDate departureDate = (LocalDate) bookingMap.get(BookingDAO.DEPARTURE_DATE);
        LocalDate arrivalDate = (LocalDate) bookingMap.get(BookingDAO.ARRIVAL_DATE);

        LocalDate departureDateToCheck;
        LocalDate arrivalDateToCheck;

        for (int i = 0; i < bookingsForThisRoomEntityResult.calculateRecordNumber(); i++) {
            Map<?, ?> bookingToCheck = bookingsForThisRoomEntityResult.getRecordValues(i);

            departureDateToCheck = (LocalDate) bookingToCheck.get(BookingDAO.DEPARTURE_DATE);
            arrivalDateToCheck = (LocalDate) bookingToCheck.get(BookingDAO.ARRIVAL_DATE);

            if (
                    (arrivalDate.isAfter(arrivalDateToCheck) || arrivalDate.isEqual(arrivalDateToCheck)) &&
                            (departureDate.isBefore(departureDateToCheck) || departureDate.isEqual(departureDateToCheck))
            ) {
                return true;
            }
        }

        return false;
    };

    private void validateBooking(Map<?, ?> attrMap, BiPredicate<Map<?, ?>, EntityResult> overlapTestPredicate) throws InvalidBookingDNIException, InvalidBookingDateException {
        if (!validateDNI((String) attrMap.get(BookingDAO.DNI))) {
            throw new InvalidBookingDNIException("The DNI is not valid");
        }

        if (arrivalDateBeforeNow.test(attrMap)) {
            throw new InvalidBookingDateException("The arrival date must be after now");
        }

        if (departureDateBeforeArrivalDate.test(attrMap)) {
            throw new InvalidBookingDateException("The departure date must be after arrival date");
        }

        Map<String, Integer> filter = new HashMap<>();
        filter.put(BookingDAO.ROOM_ID, (Integer) attrMap.get(BookingDAO.ROOM_ID));
        List<String> queriedAtributeList = List.of(BookingDAO.ARRIVAL_DATE, BookingDAO.DEPARTURE_DATE, BookingDAO.ROOM_ID);

        EntityResult bookingsForThisRoomEntityResult = bookingQuery(filter, queriedAtributeList);

        if (overlapTestPredicate.test(attrMap, bookingsForThisRoomEntityResult)) {
            throw new InvalidBookingDateException("Occupied room in those dates");
        }
    }

    public boolean validateDNI(String dni) {
        List<Character> letters = List.of(
                'T', 'R', 'W', 'A', 'G', 'M', 'Y', 'F', 'P', 'D', 'X', 'B', 'N', 'J', 'Z', 'S', 'Q', 'V', 'H',
                'L', 'C', 'K', 'E'
        );

        if (dni.length() != 9) {
            return false;
        }

        dni = dni.toUpperCase();

        if (!dni.matches("\\d{8}[A-HJ-NP-TV-Z]")) {
            return false;
        }

        int numberSegment = Integer.parseInt(dni.substring(0, 8));
        char letter = dni.charAt(8);

        return letters.get(numberSegment % 23) == letter;
    }

    @Override
    public EntityResult bookingQuery(Map<?, ?> keymap, List<?> attrList) {
        return this.daoHelper.query(this.bookingDAO, keymap, attrList);
    }

    @Override
    public EntityResult bookingInsert(Map<?, ?> attrMap) throws InvalidBookingDateException, InvalidBookingDNIException {
        validateBooking(attrMap, datesOverlapForRoom);

        return this.daoHelper.insert(this.bookingDAO, attrMap);
    }

    @Override
    public EntityResult bookingDelete(Map<?, ?> keyMap) throws Exception {
        Integer bookingId = (Integer) keyMap.get(BookingDAO.ID);

        //if (!this.daoHelper.query(hotelDAO, keyMap, List.of("hotel_id"),HotelDAO.QUERY_BOOKINGS_IN_HOTEL).isEmpty()){
        //    throw new Exception("This hotel has booked rooms");
        //}

        if (this.daoHelper.query(bookingDAO, keyMap, List.of(RoomDAO.ID)).isEmpty()) {
            EntityResult result = this.daoHelper.delete(bookingDAO, keyMap);
            result.setMessage("No booking with this id");
            result.setCode(EntityResult.OPERATION_WRONG);
            return result;
        }

        EntityResult result = this.daoHelper.delete(bookingDAO, keyMap);
        result.setMessage("Booking deleted successfully");
        result.put("deleted_id", bookingId);
        return result;
    }

    @Override
    public EntityResult bookingUpdate(Map<?, ?> attrMap, Map<?, ?> keyMap) throws InvalidBookingDateException, InvalidBookingDNIException, BookingDoesNotExistException, BookingNotModifiableException, RoomDoesNotExistException, InvalidBookingRoomException {
        Map<String, Integer> filter = new HashMap<>();
        filter.put(BookingDAO.ID, (Integer) attrMap.get(BookingDAO.ID));
        EntityResult originalBookingEntityResult =
                daoHelper.query(bookingDAO, filter, List.of(BookingDAO.ARRIVAL_DATE, BookingDAO.ROOM_ID));

        if (originalBookingEntityResult.isEmpty()) {
            throw new BookingDoesNotExistException("A booking with this ID could not be found");
        }

        filter = new HashMap<>();
        filter.put(RoomDAO.ID, (Integer) attrMap.get(BookingDAO.ROOM_ID));
        EntityResult destinationRoomEntityResult = roomService.roomQuery(filter, List.of(RoomDAO.HOTEL_ID));

        if (destinationRoomEntityResult.isEmpty()) {
            throw new RoomDoesNotExistException("A room with the specified ID could not be found");
        }

        validateBooking(attrMap, datesOverlapForRoomExcludingThisBooking);

        Map<?, ?> originalBooking = originalBookingEntityResult.getRecordValues(0);
        LocalDate originalBookingArrivalDate = (LocalDate) originalBooking.get(BookingDAO.ARRIVAL_DATE);

        if (LocalDate.now().until(originalBookingArrivalDate, ChronoUnit.DAYS) < 1) {
            throw new BookingNotModifiableException("Bookings cannot be modified less than 24 prior to the arrival date");
        }

        filter = new HashMap<>();
        filter.put(RoomDAO.ID, (Integer) originalBooking.get(BookingDAO.ROOM_ID));
        Map<?, ?> originalRoom = roomService.roomQuery(filter, List.of(RoomDAO.HOTEL_ID)).getRecordValues(0);

        if (
                originalRoom.get(RoomDAO.HOTEL_ID) != destinationRoomEntityResult.getRecordValues(0).get(RoomDAO.HOTEL_ID)
        ) {
            throw new InvalidBookingRoomException("The new room must be in the same hotel as the original one");
        }

        EntityResult result = this.daoHelper.update(this.bookingDAO, attrMap, keyMap);
        result.put("updated_id", attrMap.get(BookingDAO.ID));

        return result;
    }
}
package com.ontimize.hr.model.core.service;

import com.ontimize.hr.api.core.service.IRoomService;
import com.ontimize.hr.api.core.service.exception.InvalidNumberOfBeds;
import com.ontimize.hr.api.core.service.exception.InvalidPriceException;
import com.ontimize.hr.api.core.service.exception.InvalidRoomNumberException;
import com.ontimize.hr.model.core.dao.HotelDAO;
import com.ontimize.hr.model.core.dao.RoomDAO;
import com.ontimize.hr.model.core.util.RoomUtils;
import com.ontimize.jee.common.dto.EntityResult;
import com.ontimize.jee.common.dto.EntityResultMapImpl;
import com.ontimize.jee.common.security.PermissionsProviderSecured;
import com.ontimize.jee.server.dao.DefaultOntimizeDaoHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Lazy
@Service("RoomService")
public class RoomService implements IRoomService {

    @Autowired
    private DefaultOntimizeDaoHelper daoHelper;
    @Autowired
    private RoomDAO roomDAO;
    @Autowired
    private HotelService hotelService;
    @Autowired
    private RoomUtils roomUtils;
    private static final int FIRST_ROOM_NUMBER = 101;
    @Secured({})
    @Override
    public EntityResult roomQuery(Map<?, ?> keymap, List<?> attrList) {
        return this.daoHelper.query(this.roomDAO, keymap, attrList);
    }

    public boolean validateRoomNumberOverMinimum(int roomNumber) {
        return roomNumber >= FIRST_ROOM_NUMBER;
    }

    public boolean validateRoomNumberRoomNonZero(int roomNumber) {
        return roomNumber % 10 != 0;
    }

    public boolean validateRoomNumberUnderMaximum(int roomNumber) {
        return roomNumber <= 9999;
    }

    public boolean validateRoomNumberEnoughFloors(int roomNumber, int numberOfFloors) {
        return roomUtils.getFloorNumber(roomNumber) <= numberOfFloors;
    }

    public void validateNumberOfBeds(int numberOfBeds) throws InvalidNumberOfBeds {
        if (numberOfBeds < 1 || numberOfBeds > 4) {
            throw new InvalidNumberOfBeds("Number of beds must be between 1 and 4");
        }
    }

    public void validatePriceOverMinimum(BigDecimal price) throws InvalidPriceException {

        if (price.compareTo(new BigDecimal("0.0")) <= 0) {
            throw new InvalidPriceException("Price must be positive");
        }
    }

    public void validateRoomNumber(int roomNumber, int numberOfFloors) throws InvalidRoomNumberException {
        if (!validateRoomNumberOverMinimum(roomNumber)) {
            throw new InvalidRoomNumberException("The roomNumber has to be over 100");
        }
        if (!validateRoomNumberUnderMaximum(roomNumber)) {
            throw new InvalidRoomNumberException("The roomNumber has to be under 10000");
        }
        if (!validateRoomNumberEnoughFloors(roomNumber, numberOfFloors)) {
            throw new InvalidRoomNumberException("This hotel has not enough floors");
        }
        if (!validateRoomNumberRoomNonZero(roomNumber)) {
            throw new InvalidRoomNumberException("The roomNumber cannot finish with 0");
        }
    }

    @Secured({PermissionsProviderSecured.SECURED})
    @Override
    @SuppressWarnings("unchecked")
    public EntityResult roomInsert(Map<?, ?> attrMap) {
        EntityResult result;

        try {
            int assignedHotelId = (int) attrMap.get(RoomDAO.HOTEL_ID);

            Map<String, Integer> keyMap = new HashMap<>();
            keyMap.put(HotelDAO.ID, assignedHotelId);

            EntityResult assignedHotelEntityResult =
                    hotelService.hotelQuery(keyMap, List.of(HotelDAO.NUMBER_OF_FLOORS));

            validateRoomNumber((int) attrMap.get(RoomDAO.ROOM_NUMBER), ((List<Integer>) assignedHotelEntityResult.get(HotelDAO.NUMBER_OF_FLOORS)).get(0));
            validateNumberOfBeds((int) attrMap.get(RoomDAO.NUMBER_OF_BEDS));
            validatePriceOverMinimum(BigDecimal.valueOf((int) attrMap.get(RoomDAO.BASE_PRICE)));
            result = this.daoHelper.insert(this.roomDAO, attrMap);
            result.setMessage("Room created successfully");
            result.setCode(EntityResult.OPERATION_SUCCESSFUL_SHOW_MESSAGE);

        } catch (DuplicateKeyException e) {
            result = new EntityResultMapImpl();
            result.setCode(EntityResult.OPERATION_WRONG);
            result.setMessage("This room already exists");
        } catch (Exception e) {
            result = new EntityResultMapImpl();
            result.setCode(EntityResult.OPERATION_WRONG);
            result.setMessage(e.getMessage());
        }

        return result;
    }

    @Secured({PermissionsProviderSecured.SECURED})
    public EntityResult roomDelete(Map<?, ?> keyMap) {

        EntityResult result;

        Integer roomId = (Integer) keyMap.get(RoomDAO.ID);

        if (this.daoHelper.query(roomDAO, keyMap, List.of(RoomDAO.ID)).isEmpty()) {
            result = this.daoHelper.delete(roomDAO, keyMap);
            result.setMessage("No rooms with this id");
            result.setCode(EntityResult.OPERATION_WRONG);
            return result;
        }

        result = this.daoHelper.delete(roomDAO, keyMap);
        result.setMessage("Room deleted successfully");
        result.put("deleted_id", roomId);
        result.setCode(EntityResult.OPERATION_SUCCESSFUL_SHOW_MESSAGE);
        return result;
    }

    @Secured({PermissionsProviderSecured.SECURED})
    @Override
    @SuppressWarnings("unchecked")
    public EntityResult roomUpdate(Map<? super Object, ? super Object> attrMap, Map<? super Object, ? super Object> keyMap) {

        EntityResult result;
        try {

            EntityResult roomEntityResult = roomQuery(keyMap, List.of(RoomDAO.HOTEL_ID));
            int assignedHotelId = ((List<Integer>) roomEntityResult.get(RoomDAO.HOTEL_ID)).get(0);

            Map<String, Integer> filter = new HashMap<>();
            filter.put(RoomDAO.HOTEL_ID, assignedHotelId);

            if (attrMap.get(RoomDAO.ROOM_NUMBER) != null) {
                EntityResult assignedHotelEntityResult =
                        hotelService.hotelQuery(filter, List.of(HotelDAO.NUMBER_OF_FLOORS));
                validateRoomNumber((int) attrMap.get(RoomDAO.ROOM_NUMBER), ((List<Integer>) assignedHotelEntityResult.get(HotelDAO.NUMBER_OF_FLOORS)).get(0));
            }

            if (attrMap.get(RoomDAO.NUMBER_OF_BEDS) != null) {
                validateNumberOfBeds((int) attrMap.get(RoomDAO.NUMBER_OF_BEDS));
            }

            result = this.daoHelper.update(this.roomDAO, attrMap, keyMap);
            result.put("updated_id", keyMap.get(RoomDAO.ID));
            result.setMessage(M_UPDATE_SUCCESS);
            result.setCode(EntityResult.OPERATION_SUCCESSFUL_SHOW_MESSAGE);
        } catch (Exception e) {
            result = new EntityResultMapImpl();
            result.setCode(EntityResult.OPERATION_WRONG);
            result.setMessage(e.getMessage());
        }
        return result;
    }

}



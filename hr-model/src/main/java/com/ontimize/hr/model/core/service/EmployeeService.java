package com.ontimize.hr.model.core.service;

import com.ontimize.hr.api.core.service.IEmployeeService;
import com.ontimize.hr.api.core.service.IUserService;
import com.ontimize.hr.model.core.dao.UserDAO;
import com.ontimize.hr.model.core.dao.UserRoleDAO;
import com.ontimize.jee.common.dto.EntityResult;
import com.ontimize.jee.common.dto.EntityResultMapImpl;
import com.ontimize.jee.common.security.PermissionsProviderSecured;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.security.access.annotation.Secured;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Lazy
@Service("EmployeeService")
public class EmployeeService implements IEmployeeService {

    @Autowired
    private UserService userService;


    @Secured({PermissionsProviderSecured.SECURED})
    @Override
    public EntityResult employeeQuery(Map<?, ?> keyMap, List<?> attrList) {
        return null;
    }

    @Secured({PermissionsProviderSecured.SECURED})

    @Override
    public EntityResult employeeInsert(Map<?, ?> attrMap) {
        return null;
    }

    @Secured({PermissionsProviderSecured.SECURED})

    @Override
    public EntityResult employeeDelete(Map<?, ?> keyMap) {
        return null;
    }

    @Secured({PermissionsProviderSecured.SECURED})
    @Override
    public EntityResult employeeUpdate(Map<?, ?> filter, Map<?, ?> attrMap) throws Exception {

        EntityResult result = null;

        try {
            if (!userService.getUserRoles((String) filter.get(UserDAO.LOGIN_NAME)).contains(UserRoleDAO.EMPLOYEE_ROLE)){
                throw new Exception(IUserService.WRONG_ROLE);
            }

            result = userService.userUpdate(attrMap,filter);

        }catch (Exception e){
            result= new EntityResultMapImpl();
            result.setCode(EntityResult.OPERATION_WRONG);
            result.setMessage(e.getMessage());
        }
        return result;
    }

}

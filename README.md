# Logging

Salesforce Logging Framework

- Provides full stack dumping and limits report
- Controlled via custom setting
- Includes custom debug, exception debugging out to custom object  


# ChangeLog

# Usage

## Logging Settings - Custom Settings

First must enable Logging with an entry to:  Logging_Settings__c (Custom Setting)
Default Organization Level Value
* Enable_Debug__c = TRUE
* Enable_Exceptions__c = TRUE

Then create a Logging_Settings__c entry for either a Profile or specific User.
* Enable_Debug__c = [TRUE, FALSE]
* Enable_Exceptions__c = [TRUE, FALSE]


Logging hooks are implemented like this within each class

## Logger Setup - required methods

```
public class myClass(){

    public void myMethod(){
      Logger.push('myMethod','myClass');
        // Somecode
      Logger.pop();
    }

}
```
Each class/method must include: Logger.push and Logger.pop in order to caputre logs for the entire class stack

## Logging Custom Exception - capturing exceptions

```
public class myClass(){

    public void myMethod(){
      Logger.push('myMethod','myClass');

        try{
            // Somecode
        catch (Exception e){
            Logger.debugException (e);
        }
        
      Logger.pop();
    }

}
```

## Logging Debug  - capturing custom debug statements

```
public class myClass(){

    public void myMethod(){
      Logger.push('myMethod','myClass');

        try{
            // Somecode
            Logger.debug('Something in here');
        catch (Exception e){
            Logger.debugException (e);
        }
        
      Logger.pop();
    }

}
```



# Issues

# Todo's
- Add support for RecordTypes

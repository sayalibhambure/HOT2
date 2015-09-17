global class ScheduleInstantiateAttendanceObject implements Schedulable{
    global void execute(SchedulableContext sc){
        InstantiateAttendanceObject attendanceInstance = new InstantiateAttendanceObject();
        attendanceInstance.dailyAttendanceCalculation();
    }
}
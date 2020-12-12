using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public class MockDailyTaskRepo : IDailyTaskRepo
    {
        public IEnumerable<DailyTask> GetAllTasks()
        {
            var tasks = new List<DailyTask>
            {
                new DailyTask{DailyTaskId = 0, Sarcina = "Tema la matematica", Prioritate = "Medie", Deadline = "13-12-2020"},
                new DailyTask{DailyTaskId = 1, Sarcina = "Tema la romana", Prioritate = "Medie", Deadline = "13-12-2020"},
                new DailyTask{DailyTaskId = 2, Sarcina = "Tema la engleza", Prioritate = "Medie", Deadline = "13-12-2020"}
            };
            return tasks;
        }
    }
}

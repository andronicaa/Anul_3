using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class DailyTask
    {

        public int DailyTaskId { get; set; }
        public string  TitluTask{ get; set; }
        public Priority Prioritate { get; set; }
        public string Deadline { get; set; }
    }
    public enum Priority
    {
        Mica, 
        Medie,
        Mare

    }
}

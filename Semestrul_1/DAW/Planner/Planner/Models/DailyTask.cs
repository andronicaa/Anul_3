using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Planner.Models
{
    public class DailyTask
    {
        public int DailyTaskId { get; set; }
        [Required(ErrorMessage = "Camp obligatoriu")]
        [StringLength(15, ErrorMessage = "Titlul trebuie sa fie de lungime cuprinsa intre 4 si 15.", MinimumLength = 4)]
        public string TitluTask { get; set; }
        [Required(ErrorMessage = "Camp obligatoriu")]
        public Priority Prioritate { get; set; }
        [Required(ErrorMessage = "Camp obligatoriu")]
        public string Deadline { get; set; }

        [Required]
        public string Detalii { get; set; }
    }
    public enum Priority
    {
        Mica, 
        Medie, 
        Mare
    }
}
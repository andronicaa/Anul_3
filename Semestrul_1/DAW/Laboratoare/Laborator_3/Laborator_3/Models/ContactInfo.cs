using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Security.Policy;
using System.Web;

namespace Laborator_3.Models
{
    public class ContactInfo
    {
        [Key]
        public int ContactInfoId { get; set; }
        public String Phonenumber { get; set; }
        public virtual Publisher Publisher { get; set; }


    }
}
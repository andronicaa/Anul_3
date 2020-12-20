using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class ContactInfo
    {
        public int ContactInfoId { get; set; }

        [Required(ErrorMessage = "Camp obligatoriu")]
        [RegularExpression(@"^(\d{10})$", ErrorMessage = "Numarul de telefon trebuie sa aiba 10 cifre")]
        public string NrTelefon { get; set; }


        [Required(ErrorMessage = "Camp obligatoriu")]
        [EmailAddress(ErrorMessage = "Aceasta adresa de email nu este valida")]
        public string Email { get; set; }


        [Required(ErrorMessage = "Camp obligatoriu")]
        public string Adresa { get; set; }

        [Required(ErrorMessage = "Camp obligatoriu")]
        [RegularExpression(@"^(\d{6})$", ErrorMessage = "Codul postal trebuie sa contina 6 cifre")]
        public string CodPostal { get; set; }

        // one-to-one relation
        
        public int PersonRef { get; set; }
        [Required]
        public virtual Person Person { get; set; }
    }
}

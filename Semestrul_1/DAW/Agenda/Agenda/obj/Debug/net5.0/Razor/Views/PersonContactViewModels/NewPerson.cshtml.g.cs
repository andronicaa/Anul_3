#pragma checksum "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "5c706548440a666aa5c0aa9fd6a96dd1e249a13e"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_PersonContactViewModels_NewPerson), @"mvc.1.0.view", @"/Views/PersonContactViewModels/NewPerson.cshtml")]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\_ViewImports.cshtml"
using Agenda;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\_ViewImports.cshtml"
using Agenda.Models;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"5c706548440a666aa5c0aa9fd6a96dd1e249a13e", @"/Views/PersonContactViewModels/NewPerson.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"d36845afd86d39266a46b24ffb4cec0212e7cd5a", @"/Views/_ViewImports.cshtml")]
    public class Views_PersonContactViewModels_NewPerson : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<Agenda.ViewModels.PersonContactViewModel>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("\r\n<h1>NewTask</h1>\r\n\r\n");
#nullable restore
#line 5 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
 using (Html.BeginForm(actionName: "CreateNewPerson", controllerName: "PersonContactViewModels", method: FormMethod.Post))
{
    

#line default
#line hidden
#nullable disable
#nullable restore
#line 7 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.Label("Nume", "Nume: "));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n");
#nullable restore
#line 9 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.TextBoxFor(b => b.Person.Nume, null, new { placeholder = "Nume...", @class = "formcontrol" }));

#line default
#line hidden
#nullable disable
#nullable restore
#line 10 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.ValidationMessageFor(b => b.Person.Nume, "", new { @class = "text-danger" }));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n    <br />\r\n");
#nullable restore
#line 13 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.Label("Prenume", "Prenume:"));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n");
#nullable restore
#line 15 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.TextBoxFor(b => b.Person.Prenume, null, new { placeholder = "Prenume", @class = "formcontrol" }));

#line default
#line hidden
#nullable disable
#nullable restore
#line 16 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.ValidationMessageFor(b => b.Person.Prenume, "", new { @class = "text-danger" }));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n    <br />\r\n");
#nullable restore
#line 19 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.Label("Adresa", "Adresa:"));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n");
#nullable restore
#line 21 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.TextBoxFor(b => b.ContactInfo.Adresa, null, new { placeholder = "Adresa", @class = "formcontrol" }));

#line default
#line hidden
#nullable disable
#nullable restore
#line 22 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.ValidationMessageFor(b => b.ContactInfo.Adresa, "", new { @class = "text-danger" }));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n    <br />\r\n");
#nullable restore
#line 25 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.Label("NrTelefon", "NrTelefon:"));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n");
#nullable restore
#line 27 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.TextBoxFor(b => b.ContactInfo.NrTelefon, null, new { placeholder = "Adresa", @class = "formcontrol" }));

#line default
#line hidden
#nullable disable
#nullable restore
#line 28 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.ValidationMessageFor(b => b.ContactInfo.NrTelefon, "", new { @class = "text-danger" }));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n    <br />\r\n");
#nullable restore
#line 31 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.Label("Email", "Email:"));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n");
#nullable restore
#line 33 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.TextBoxFor(b => b.ContactInfo.Email, null, new { placeholder = "Email", @class = "formcontrol" }));

#line default
#line hidden
#nullable disable
#nullable restore
#line 34 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.ValidationMessageFor(b => b.ContactInfo.Email, "", new { @class = "text-danger" }));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n    <br />\r\n");
#nullable restore
#line 37 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.Label("CodPostal", "CodPostal:"));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n");
#nullable restore
#line 39 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.TextBoxFor(b => b.ContactInfo.CodPostal, null, new { placeholder = "CodPostal", @class = "formcontrol" }));

#line default
#line hidden
#nullable disable
#nullable restore
#line 40 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
Write(Html.ValidationMessageFor(b => b.ContactInfo.CodPostal, "", new { @class = "text-danger" }));

#line default
#line hidden
#nullable disable
            WriteLiteral("    <br />\r\n    <br />\r\n    <button class=\"btn btn-primary\" type=\"submit\">Adauga profil</button>\r\n");
#nullable restore
#line 44 "C:\Users\Personal\Desktop\Anul_3\Semestrul_1\DAW\Agenda\Agenda\Views\PersonContactViewModels\NewPerson.cshtml"
}

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n\r\n");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<Agenda.ViewModels.PersonContactViewModel> Html { get; private set; }
    }
}
#pragma warning restore 1591
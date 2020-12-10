using Commander.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Commander.Data
{
    public interface ICommanderRepo
    {
        bool SaveChanges();
        // returnam toate comenzile din baza de date
        IEnumerable<Command> GetAppCommands();

        Command GetCommandById(int id);

        void CreateCommand(Command cmd);

        void UpdateCommand(Command cmd);


    }
}

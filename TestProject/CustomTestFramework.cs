using Xunit.Abstractions;
using Xunit.Sdk;
[assembly: Xunit.TestFramework("TestProject.CustomTestFramework", "TestProject")]

namespace TestProject
{
    public class CustomTestFramework : XunitTestFramework
    {
        public CustomTestFramework(IMessageSink messageSink)
            : base(messageSink)
        {
            messageSink.OnMessage(new DiagnosticMessage("Using CustomTestFramework"));
        }
    }
}

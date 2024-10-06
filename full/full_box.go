package main

import (
	"os"

	_ "github.com/ilius/qt/interop"

	"github.com/ilius/qt/core"
	_ "github.com/ilius/qt/gui"
	_ "github.com/ilius/qt/multimedia"
	_ "github.com/ilius/qt/quick"
	_ "github.com/ilius/qt/quickcontrols2"
	"github.com/ilius/qt/widgets"
)

func main() {

	// enable high dpi scaling
	// useful for devices with high pixel density displays
	// such as smartphones, retina displays, ...
	core.QCoreApplication_SetAttribute(core.Qt__AA_EnableHighDpiScaling, true)

	widgets.NewQApplication(len(os.Args), os.Args)

	widgets.QApplication_Exec()
}

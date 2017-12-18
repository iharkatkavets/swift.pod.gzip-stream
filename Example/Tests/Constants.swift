//
//  Constants.swift
//  ZipStream_Tests
//
//  Created by Igor Kotkovets on 12/18/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct Constants {
    static let originText = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent enim erat, varius consectetur varius a, facilisis vel est. Pellentesque elit dui, viverra a tortor nec, finibus fringilla augue. Ut finibus lacus sit amet quam euismod, et placerat felis venenatis. Quisque sit amet magna vel quam lacinia gravida et non lacus. Sed maximus nisi nec nibh dapibus facilisis. Maecenas interdum libero elit, a fringilla diam vulputate eget. Vestibulum varius purus lacus, vel egestas nibh viverra dignissim. Cras orci neque, dictum nec leo et, vestibulum viverra quam. Sed congue egestas velit. In leo ex, varius quis tortor ac, vestibulum feugiat lorem. Praesent efficitur, est vel rhoncus luctus, diam velit dapibus urna, sed elementum lectus nulla vitae eros.

Nulla congue convallis odio, et ultricies lectus bibendum nec. Phasellus molestie diam ut dui finibus aliquet semper sed turpis. Nam nec efficitur purus, sit amet molestie quam. Interdum et malesuada fames ac ante ipsum primis in faucibus. Proin viverra mattis velit id bibendum. Proin rhoncus dignissim lobortis. Sed eget scelerisque ligula. Nam convallis imperdiet odio ac vehicula.

Mauris sem quam, pulvinar volutpat justo ac, ornare fringilla nisi. Donec massa lectus, eleifend at tincidunt non, egestas id urna. Curabitur blandit ac velit quis viverra. Donec semper dolor sed justo egestas, eu ultrices velit pretium. Donec sed elementum nibh, in facilisis risus. Proin eu tincidunt sem. Vivamus ac sodales diam, in maximus sem. Vivamus tincidunt nisl efficitur enim tempor, id viverra dolor semper. Curabitur lobortis varius nibh non tempor. Suspendisse sed neque et lectus pellentesque tincidunt. Fusce vitae dui vehicula, mollis leo sed, aliquam mauris. Donec fermentum quam id turpis ornare gravida. Integer lacinia, elit eget fringilla mattis, ligula turpis tempor diam, eget pulvinar turpis nunc pulvinar libero. Pellentesque id commodo nibh. Curabitur non mollis sem.

Curabitur rutrum, ante vel convallis rutrum, tellus risus fringilla tellus, id rhoncus dui turpis ac ligula. Fusce quis purus vestibulum mauris tristique commodo. Quisque interdum placerat lectus. Sed interdum ipsum ut volutpat posuere. Praesent aliquet, risus sed efficitur convallis, urna felis tempor nulla, a commodo mi metus eget nisl. Nulla tempor, odio ut tempus dictum, eros mi eleifend est, eu eleifend erat velit finibus libero. Morbi in placerat quam, sed commodo diam. Maecenas eget egestas est. Mauris sit amet aliquet neque, a accumsan neque. Nullam fermentum porta laoreet.

Praesent pulvinar neque at feugiat luctus. Vestibulum justo ex, mattis eu libero sed, pretium interdum felis. Integer id sodales ipsum, ut rhoncus justo. Sed in arcu sem. In condimentum venenatis odio, ac cursus magna elementum id. Nunc feugiat semper felis et rhoncus. Proin molestie, ex iaculis consectetur ultrices, ligula lorem sollicitudin eros, ut viverra dolor ligula id magna. Nam gravida a leo non posuere. Praesent pulvinar sollicitudin justo sit amet rhoncus. Quisque id purus a leo blandit pretium tristique tincidunt quam.
"""
    static let gzipBase64Text = "H4sIAAAAAAAA/2VW7W7kNgz8v0+hBzD2Ja4ocEBzaFH0/mtl7YaFLDn6MPL4HZKS7PSA4HKxJIozHA71R8p+M7SXtpk1hZRNoWrs5utiXIrFu+pry8autFNxFF/GB6p382e2vvhYjY+0GZ8tDhw2UytfzvVPdjFP6yhQoWIOH4wvHMOHgBC+fDQvYc3aCGHo8DlbY01NGT8meofzFOmBUM+MJCgErLdX83fzT51rwTr8OxCYj2aRWqOypXUx+LBjA6dqnriNE4k+2krlbv7CLs5int3sK1pJVaLgIO6w5pXtQavlYDFFvfBu/vYrDnzShtsjMHLG+M/j3ax216wH+rt5s97h2mII0PMK4gM9fE7CwALUJ8KVcPXRwt6qraDo5cHaT3CHmAEHO7t7ywP8ouy+sMcWTWHQudILuRXa7uZbxmLKjhMF6gVrriIepx08MuFiXq7pEZgJBYsSv5qf9xyqie9RT39OKXyA1lFF674Effr2IpQisAKveno+yRG0s7BIBE5+T5ELGxqyLEunRQXT+W05QmMFqfngN8RhWj1vN7ExlQdVi4RzKvfb7Yd86iDw67CB9ZBWSqKTFmpGEr6MGA9UKK7KEHJ9twXSxfctBUbkNaUmAp5qtIFAbkVW2+6zJAdYO2vgh1WyJ1it4XLR34ispH8fWhFpYqlZqPCJrbjHGYvl3sV7po1YXFhtjhNhchP+HmXcbK3Ui2ZoneDGvkH3FAxq9EANqSudZWiKA9FZmybQqwWrqE42iVGvhL3MK2d5+HdyvPN2e7MNh5kaAbgAfzgoWjhGCq3uEMa/rdQkqkkobvaXvuAeu5vfElO42VJsr9PC1acn0BgEqBQdrS1Kqy5TrEDMakEXtGwfQv4j2Lgy866zIrrtfI2Lehm7S4IHTbCHRfzWdeMHt3v2lZjXEeCqTu7NRcs0jBGMnNVCuBNA4Rb5SYdlh0GWJa0sApGdBBnu82XjhQAq4SI28ewKPAldBj6mRXRsDPTKz6j/aGvxFfY/jQFZtLKDdajFC0yxFdZq75/96vQzrbv5vUFHvTe5dYZCFtY/i4j9BAEXbSboaxPhDEqfPnc6ZZFGhw3JdLvW/nmhet3HFx03ouRTVtoYS9fzCKUYO9VyYmq174gtuvOjuvn/phuxZ26YQ0nIu5LLPHa0XL3b7VzKreaGW6W92QnP7hpLVY1IpHOBop+luLOdwW9PGAoaPasVEL3rGLlYtHJtoGl8+hCrFAjnuJwjbE5WLbgaxVxVZ4I9zubeU2k++4vvd7dcOhRplinYiXuR3u3zu1dGDJ4H52B4IwMLRRCpFmsf3tSUFtW8OBLy4b/F6Xj8LTIe+PR0EXAhjX1+YIza3fPR0ev9lvKDuBcnF+psxZ+1ZxFdXgCS3/AleRINXxxjYMyQPqfx6HGubcVG/dJxbZdGAL4KP7QYq3gt3G6T4ClQbU55BfUR3LRml5dF9zZM8j4tQEJ/pkg7dms7SywVOfsMuhseJcVfmO2hRAk+JGJsdk19C+8HFHqljmQ+z/pghmpdyywOfZydXkorExHdRNS9WmXi583DW8dwRW0/DeHdxNuuz9Zh5NML5JUCSNAgK3Jlg4ZYBNZX9+wHaNUsdSqOZ6MVQ+OO/7UBZn2+3KKFmHqYQGYHrr1vNfSYZKM+Z++ew0BeFP8BAUTjDfkLAAA="

    static let gzipData = Data(base64Encoded: gzipBase64Text)!
    static let originData = originText.data(using: .utf8)!

    
}

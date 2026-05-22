const { User } = require('../models');

// @desc    Get all users
// @route   GET /api/users
// @access  Private/Admin
exports.getAllUsers = async (req, res) => {
    try {
        const users = await User.findAll({
            attributes: { exclude: ['password'] }
        });

        res.json({ users });
    } catch (error) {
        console.error('Get all users error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};

// @desc    Get user by ID
// @route   GET /api/users/:id
// @access  Private
exports.getUserById = async (req, res) => {
    try {
        const user = await User.findByPk(req.params.id, {
            attributes: { exclude: ['password'] }
        });

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json({ user });
    } catch (error) {
        console.error('Get user error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};

// @desc    Update user
// @route   PUT /api/users/:id
// @access  Private
exports.updateUser = async (req, res) => {
    try {
        const { full_name, phone } = req.body;
        const userId = req.params.id;

        // Check if user can update (own profile or admin)
        if (req.user.id !== parseInt(userId) && req.user.role !== 'admin') {
            return res.status(403).json({ error: 'Not authorized to update this user' });
        }

        const user = await User.findByPk(userId);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        await user.update({ full_name, phone });

        res.json({
            message: 'User updated successfully',
            user: {
                id: user.id,
                email: user.email,
                full_name: user.full_name,
                phone: user.phone,
                role: user.role
            }
        });
    } catch (error) {
        console.error('Update user error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};

// @desc    Get all inspectors
// @route   GET /api/users/inspectors
// @access  Private/Admin
exports.getInspectors = async (req, res) => {
    try {
        const inspectors = await User.findAll({
            where: { role: 'inspector', is_active: true },
            attributes: { exclude: ['password'] }
        });

        res.json({ inspectors });
    } catch (error) {
        console.error('Get inspectors error:', error);
        res.status(500).json({ error: 'Server error' });
    }
};
